module ConstZero(output wire out);
    // This module outputs a constant zero using a tied gate-level net
    assign out = 1'b0;
endmodule

module TopModule(output wire zero);
    // Instantiate ConstZero module to drive zero output
    ConstZero const_zero_inst(.out(zero));
endmodule