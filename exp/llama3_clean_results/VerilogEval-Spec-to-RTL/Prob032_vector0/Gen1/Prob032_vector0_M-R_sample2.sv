module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Direct assign statement implementation (Preferred for combinational logic)
assign outv = vec;
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

// Equivalent implementation using always block (for demonstration)
// always @(*) begin
//     outv = vec;
//     o2 = vec[2];
//     o1 = vec[1];
//     o0 = vec[0];
// end

endmodule