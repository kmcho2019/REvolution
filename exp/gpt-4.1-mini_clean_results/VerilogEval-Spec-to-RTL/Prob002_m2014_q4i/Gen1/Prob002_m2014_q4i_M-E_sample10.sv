module TopModule(
    output out
);
    localparam ZERO = 1'b0;
    wire zero_wire;
    
    assign zero_wire = ZERO;
    assign out = zero_wire;
endmodule