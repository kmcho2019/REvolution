module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // 0: S0, 1: S1

always @(posedge clock) begin
    if (a) begin
        state <= 1; // Transition to S1
    end else begin
        state <= 0; // Transition to S0
    end
end

always @(negedge clock) begin
    if (state == 1) begin
        q <= 1; // Set q to 1 when in S1
    end else begin
        q <= 0; // Set q to 0 when in S0
    end
end

always @(*) begin
    if (state == 1 && clock) begin
        p <= 1; // Set p to 1 when in S1 and clock is high
    end else begin
        p <= 0; // Set p to 0 otherwise
    end
end

endmodule