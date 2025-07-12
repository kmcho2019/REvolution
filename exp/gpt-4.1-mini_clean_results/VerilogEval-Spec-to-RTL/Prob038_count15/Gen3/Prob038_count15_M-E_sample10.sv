module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Internal registers to hold the state of each T flip-flop
reg q0, q1, q2, q3;

always @(posedge clk) begin
    if (reset) begin
        q0 <= 0;
        q1 <= 0;
        q2 <= 0;
        q3 <= 0;
    end else begin
        q0 <= ~q0;               // LSB toggles every clock
        q1 <= q1 ^ q0;           // toggles when q0 is high
        q2 <= q2 ^ (q0 & q1);    // toggles when q0 and q1 both high
        q3 <= q3 ^ (q0 & q1 & q2); // toggles when q0, q1, q2 all high
    end
end

always @* begin
    q = {q3, q2, q1, q0};
end

endmodule