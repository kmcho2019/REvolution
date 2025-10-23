module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output          valid_out,
    output [15:0]   data_out
);

    // Internal registers
    reg        flag;             // Indicates if first byte is stored
    reg [7:0]  first_byte;       // Stores first valid input byte
    reg [15:0] concat_data;      // Concatenated data at second input
    reg        valid_out_reg;    // Registered valid output signal
    reg [15:0] data_out_reg;     // Registered output data

    // Latch first byte and build concatenated data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag          <= 1'b0;
            first_byte    <= 8'd0;
            concat_data   <= 16'd0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 16'd0;
        end else begin
            valid_out_reg <= 1'b0;  // Default clear valid_out each cycle

            if (valid_in) begin
                if (!flag) begin
                    // First byte arriving, store it and set flag
                    first_byte <= data_in;
                    flag       <= 1'b1;
                end else begin
                    // Second byte arriving, concatenate and clear flag
                    concat_data   <= {first_byte, data_in};
                    valid_out_reg <= 1'b1; // Valid output will be asserted next cycle
                    flag          <= 1'b0;
                end
            end

            // Output valid and data are delayed one cycle after second input
            if (valid_out_reg) begin
                data_out_reg <= concat_data;
            end else if (!valid_out_reg && !flag) begin
                // When no output valid, keep previous data or reset if desired
                // Here keep data_out_reg stable to avoid glitches
                data_out_reg <= data_out_reg;
            end
        end
    end

    // Assign outputs
    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule