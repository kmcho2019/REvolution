module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk)
    q <= ~a;

// Consider adding clock gating if 'a' has periods of inactivity to reduce power consumption
// However, without specific information on 'a' activity, direct optimization is challenging
// The provided solution is already quite efficient and straightforward

endmodule