// Alternative 1: Using explicit wire
module TopModule(input in, output out);
    wire connection;
    assign connection = in;
    assign out = connection;
endmodule

// Alternative 2: Using always block
module TopModule(input in, output out);
    reg out_reg;
    always @(*) begin
        out_reg = in;
    end
    assign out = out_reg;
endmodule