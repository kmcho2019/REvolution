module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    p <= a;            // p captures a value at clock edge
    prev_p <= p;       // Store previous p value
    q <= prev_p & ~a;  // q is high if p was high last cycle and a is low now
end

initial begin
    p = 1'b0;
    q = 1'b0;
    prev_p = 1'b0;
end

endmodule