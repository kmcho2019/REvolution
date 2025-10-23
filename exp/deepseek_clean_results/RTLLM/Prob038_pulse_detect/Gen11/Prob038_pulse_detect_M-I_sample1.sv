module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 2'b00;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new data
        shift_reg <= {shift_reg[0], data_in};
        
        // Detect pattern: previous=1, current=0, and new input=0
        // (which means we saw 0->1->0 over three cycles)
        data_out <= (shift_reg == 2'b10) && (data_in == 1'b0);
    end
end

endmodule