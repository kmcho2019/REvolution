(* no_retiming *)
module TopModule (
    input  [7:0] in,
    output wire [31:0] out
);
    // Sign-extend 8-bit input to 32 bits by replicating the sign bit (MSB) 24 times
    assign out = {{24{in[7]}}, in};
endmodule