module TopModule(clk, in, out);
    input clk;
    input in;
    output out;

    reg out_reg; // internal register to hold the output value
    assign out = out_reg; // continuous assignment to drive the output

    always @ (posedge clk) // positive edge triggered
    begin
        out_reg <= in ^ out_reg; // XOR operation and assignment to the register
    end
endmodule