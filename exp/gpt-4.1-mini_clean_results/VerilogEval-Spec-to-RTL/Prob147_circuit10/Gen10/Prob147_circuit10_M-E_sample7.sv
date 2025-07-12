module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    if (b) begin
        if (a)
            next_state = 1'b0;      // reset state to 0 when b=1 and a=1
        else
            next_state = ~state;    // toggle state when b=1 and a=0
        q = a ^ state;              // q is XOR of a and current state when b=1
    end else begin
        next_state = state;         // hold state when b=0
        q = state;                  // q outputs current state when b=0
    end
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule