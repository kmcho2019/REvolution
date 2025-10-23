module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg state; // current state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
    end else if (state == 0) begin
        state <= j? 1 : 0;
    end else begin
        state <= ~k? 1 : 0;
    end
end

assign out = state;

endmodule