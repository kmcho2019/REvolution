module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] shift_reg;  // Stores last two samples

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 2'b00;
        data_out <= 1'b0;
    end else begin
        // Shift in new data
        shift_reg <= {shift_reg[0], data_in};
        
        // Detect 010 pattern (current=0, prev=1, prev_prev=0)
        data_out <= (data_in == 0) && (shift_reg == 2'b10);
    end
end

endmodule