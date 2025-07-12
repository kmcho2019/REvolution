module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    p <= a ? 1'b1 : 1'b0;  // Only set p to 1 when a is 1 at clock edge
    prev_p <= p;            // Store previous p value
end

always @(negedge clock) begin
    q <= prev_p;            // Update q at negative edge using stored p value
end

endmodule