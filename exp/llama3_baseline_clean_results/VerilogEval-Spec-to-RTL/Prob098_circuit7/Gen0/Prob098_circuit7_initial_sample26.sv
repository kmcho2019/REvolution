module TopModule(
    input clk,
    input a,
    output reg q
);

reg state; // 0: q = 1, 1: q = 0
reg prev_a;

always @(posedge clk) begin
    if (a == 1'b0) begin
        state <= 1'b0; // set q = 1 when a = 0
    end else if (prev_a == 1'b1) begin
        state <= ~state; // toggle q when a = 1 for two consecutive clock cycles
    end
    prev_a <= a;
end

always @(*) begin
    q = ~state; // q is the inverse of state
end

initial begin
    state = 1'b1; // initialize state to q = 1
    prev_a = 1'b0;
end

endmodule