module TopModule(output reg one);
    initial one = 1'b1;
    always @(*) begin
        one = 1'b1;
    end
endmodule