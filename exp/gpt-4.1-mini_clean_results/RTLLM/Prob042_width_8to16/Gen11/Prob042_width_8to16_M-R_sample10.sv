module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output          valid_out,
    output [15:0]   data_out
);

    reg         data_lock;          // Flag to indicate first byte stored
    reg [7:0]   first_byte;         // Storage for first byte input

    reg [15:0]  out_data_reg;       // Holds concatenated output data before output stage
    reg         out_valid_reg;      // Holds valid signal before output stage

    reg [15:0]  data_out_reg;       // Pipeline register for output data
    reg         valid_out_reg;      // Pipeline register for valid_out

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 1'b0;
            first_byte    <= 8'd0;
            out_data_reg  <= 16'd0;
            out_valid_reg <= 1'b0;
            data_out_reg  <= 16'd0;
            valid_out_reg <= 1'b0;
        end else begin
            // Default no output valid this cycle
            out_valid_reg <= 1'b0;

            if (valid_in) begin
                if (!data_lock) begin
                    // First byte arrives, store it and set flag
                    first_byte <= data_in;
                    data_lock  <= 1'b1;
                end else begin
                    // Second byte arrives, concatenate with stored byte
                    out_data_reg  <= {first_byte, data_in};
                    out_valid_reg <= 1'b1;  // Mark output valid next cycle
                    data_lock     <= 1'b0;  // Clear flag to prepare for next pair
                end
            end

            // Pipeline output registers
            valid_out_reg <= out_valid_reg;
            data_out_reg  <= out_data_reg;
        end
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule