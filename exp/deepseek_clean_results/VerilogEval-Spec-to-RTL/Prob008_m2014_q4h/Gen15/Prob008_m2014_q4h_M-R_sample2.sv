// Version 1: Explicit wire declaration
module TopModule(input in, output out);
    wire connection;
    assign connection = in;
    assign out = connection;
endmodule

// Version 2: Using always block
module TopModule(input in, output out);
    reg out_reg;
    always @(*) begin
        out_reg = in;
    end
    assign out = out_reg;
endmodule