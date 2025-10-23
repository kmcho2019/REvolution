(* no_retiming *)
module TopModule (
    input  [7:0] in,
    output wire [31:0] out
);
    // Interpret 'in' as signed 8-bit and assign to 32-bit signed wire to perform sign-extension
    // This relies on synthesis tool's signed extension mechanism for potentially better optimization
    assign out = $signed(in);
endmodule