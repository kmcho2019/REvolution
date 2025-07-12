module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if(a) begin
        state <= ~state; // Toggle state when a is 1
    end else begin
        state <= state; // Keep state the same when a is 0
    end
end

always @(*) begin
    if(b) begin
        q = state; // q is the same as state when b is 1
    end else begin
        q = ~state; // q is the inverse of state when b is 0
    end
end

endmodule