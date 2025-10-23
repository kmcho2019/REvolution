module ConstZero(output wire out);
    // Output is always tied low
    assign out = 1'b0;
endmodule

module TopModule(output wire zero);
    // Instantiate ConstZero to drive zero output
    ConstZero cz_inst(.out(zero));
endmodule