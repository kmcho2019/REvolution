module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Optimal implementation - can't be improved for PPA
    assign out = {{24{in[7]}}, in};
endmodule