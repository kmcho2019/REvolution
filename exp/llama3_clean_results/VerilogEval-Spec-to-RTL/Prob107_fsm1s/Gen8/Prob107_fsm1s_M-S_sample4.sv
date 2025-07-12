module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state;

assign out = ~state; // Out is 1 in state B (0) and 0 in state A (1)

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0;
    end else if (~state && ~in) begin
        state <= 1'b1;
    end else if (state && ~in) begin
        state <= 1'b0;
    end
end

endmodule