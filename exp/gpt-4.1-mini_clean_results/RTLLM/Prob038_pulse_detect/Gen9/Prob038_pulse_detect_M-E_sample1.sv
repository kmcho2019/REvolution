module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 2'b00;
            data_out <= 1'b0;
        end else begin
            // shift in the current data_in sample
            shift_reg <= {shift_reg[0], data_in};

            // Check if the pattern 0->1->0 occurred in last 3 samples:
            // previous two samples in shift_reg[1], shift_reg[0], current sample data_in
            // Pattern: shift_reg[1] == 0, shift_reg[0] == 1, data_in == 0
            if (shift_reg == 2'b01 && data_in == 1'b0) 
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule