module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity as XOR of all input bits using reduction XOR (^).
    // The reduction XOR operator synthesizes into a balanced XOR tree with minimal logic depth,
    // which is optimal for performance by minimizing delay in combinational logic.
    //
    // Power consumption is low because the logic is purely combinational with minimal switching.
    // Area is minimized as the synthesis tool maps the reduction operator into an efficient XOR gate tree.
    //
    // No sequential elements or gating are used, making the design simple and efficient.
    // This combination ensures the best balance of performance, power, and area (PPA).
    assign parity = ^in;
endmodule