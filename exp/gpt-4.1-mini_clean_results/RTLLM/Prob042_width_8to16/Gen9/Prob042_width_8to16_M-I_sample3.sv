module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output          valid_out,
    output [15:0]   data_out
);

    // Internal registers
    reg        flag;              // Indicates if first byte is stored
    reg [7:0]  first_byte;        // Stores first valid input byte
    reg [15:0] concat_data;       // Holds concatenated data after second byte arrival
    reg        valid_out_pipe;    // Delayed valid_out signal
    reg [15:0] data_out_reg;      // Registered output data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag           <= 1'b0;
            first_byte     <= 8'd0;
            concat_data    <= 16'd0;
            valid_out_pipe <= 1'b0;
            data_out_reg   <= 16'd0;
        end else begin
            valid_out_pipe <= 1'b0; // Default clear valid_out each cycle

            if (valid_in) begin
                if (!flag) begin
                    // First valid byte arriving: store it and set flag
                    first_byte <= data_in;
                    flag       <= 1'b1;
                end else begin
                    // Second valid byte arriving: concatenate and clear flag
                    concat_data <= {first_byte, data_in};
                    flag        <= 1'b0;
                    valid_out_pipe <= 1'b1;  // Raise valid_out in next cycle
                end
            end

            // Update output data and valid on cycle *after* second byte arrival
            if (valid_out_pipe) begin
                data_out_reg <= concat_data;
            end
        end
    end

    assign valid_out = valid_out_pipe;
    assign data_out  = data_out_reg;

endmodule