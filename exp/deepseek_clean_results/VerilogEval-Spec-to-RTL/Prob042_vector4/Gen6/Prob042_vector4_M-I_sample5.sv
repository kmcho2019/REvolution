module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Optimal sign-extension using replication operator
    assign out = {{24{in[7]}}, in};
endmodule