module TopModule(output zero);
    wire zero_wire;
    assign zero_wire = 1'b0;
    assign zero = zero_wire;
endmodule