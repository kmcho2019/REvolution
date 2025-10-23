module MUX4to1 (
    input  [1:0] sel,
    input        d0,
    input        d1,
    input        d2,
    input        d3,
    output       y
);
    // Use a combinational case to select one input based on sel
    reg y_reg;
    always @(*) begin
        case (sel)
            2'b00: y_reg = d0;
            2'b01: y_reg = d1;
            2'b10: y_reg = d2;
            2'b11: y_reg = d3;
            default: y_reg = 1'b0;
        endcase
    end
    assign y = y_reg;
endmodule

module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    // Select lines combined as {x3,x2}
    wire [1:0] sel = {x3, x2};

    // Data inputs for MUX according to truth table mapping
    // d0 = 0 (for 00)
    // d1 = 1 (for 01)
    // d2 = x1 (for 10)
    // d3 = x1 (for 11)
    MUX4to1 mux4_inst (
        .sel(sel),
        .d0(1'b0),
        .d1(1'b1),
        .d2(x1),
        .d3(x1),
        .y(f)
    );
endmodule