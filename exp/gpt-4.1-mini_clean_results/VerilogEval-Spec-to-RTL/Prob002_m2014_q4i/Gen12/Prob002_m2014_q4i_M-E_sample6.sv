module ZeroReg (
    output reg out
);
    initial out = 1'b0;
endmodule

module TopModule (
    output out
);

    ZeroReg u_zero_reg(.out(out));

endmodule