module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

wire c_lt_4 = (c < 4);
wire [1:0] idx = c[1:0];

// Create a 4-input mux from {b, e, a, d} indexed by idx
wire [3:0] mux_out;

assign mux_out = (idx == 2'd0) ? b :
                 (idx == 2'd1) ? e :
                 (idx == 2'd2) ? a :
                 d; // idx == 3

always @(*) begin
    if (c_lt_4)
        q = mux_out;
    else
        q = 4'hF;
end

endmodule