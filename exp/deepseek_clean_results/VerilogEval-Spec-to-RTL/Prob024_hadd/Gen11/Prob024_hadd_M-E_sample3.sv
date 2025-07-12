module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    reg [1:0] result;
    
    always @(*) begin
        case ({a, b})
            2'b00: result = 2'b00;
            2'b01: result = 2'b10;
            2'b10: result = 2'b10;
            2'b11: result = 2'b01;
        endcase
    end
    
    assign sum = result[1];
    assign cout = result[0];
endmodule