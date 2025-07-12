module TopModule(output reg one);
    initial one = 1'b1;
    always @(*) begin
        // Keep output stable at 1
        one = 1'b1;
    end
endmodule