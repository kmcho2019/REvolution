module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output         valid_out,
    output [15:0]  data_out
);

    reg         has_first_byte;
    reg  [7:0]  first_byte;

    // Registers to hold output data and valid signal, delayed by one cycle after second input
    reg         valid_out_reg;
    reg  [15:0] data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            has_first_byte <= 1'b0;
            first_byte     <= 8'd0;
            valid_out_reg  <= 1'b0;
            data_out_reg   <= 16'd0;
        end else begin
            valid_out_reg <= 1'b0;  // Default deassert output valid

            if (valid_in) begin
                if (!has_first_byte) begin
                    // Store first byte and set flag
                    first_byte     <= data_in;
                    has_first_byte <= 1'b1;
                end else begin
                    // Second byte received, concatenate and assert output valid next cycle
                    data_out_reg   <= {first_byte, data_in};
                    valid_out_reg  <= 1'b1;
                    has_first_byte <= 1'b0;  // Clear flag after outputting data
                end
            end
            // If valid_in is low, hold current state
        end
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule