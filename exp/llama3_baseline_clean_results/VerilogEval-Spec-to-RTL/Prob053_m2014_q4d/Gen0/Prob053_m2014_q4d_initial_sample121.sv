module TopModule(clk, in, out);
    input clk;
    input in;
    output out;

    reg out_reg; // internal register to hold the output value
    assign out = out_reg; // continuous assignment for output

    always @(posedge clk) // positive edge triggered
        out_reg <= in ^ out_reg; // XOR 'in' with current 'out' and update 'out_reg'
endmodule