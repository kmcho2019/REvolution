module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
    end else begin
        // Circular shift implementation
        shift_reg <= {shift_reg[6:0], shift_reg[7]};
        // Load new data when shifting would complete a full cycle
        if (&shift_reg == 1'b0) begin
            shift_reg <= d;
        end
    end
end

assign q = shift_reg;

endmodule