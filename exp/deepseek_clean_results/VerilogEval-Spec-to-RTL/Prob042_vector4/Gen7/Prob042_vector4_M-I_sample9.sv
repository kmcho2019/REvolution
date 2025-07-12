module TopModule (
    input [7:0] in,
    output [31:0] out
);
    // Gradual sign extension to potentially reduce switching power
    wire [15:0] first_ext = {{8{in[7]}}, in};
    assign out = {{16{first_ext[15]}}, first_ext};
endmodule