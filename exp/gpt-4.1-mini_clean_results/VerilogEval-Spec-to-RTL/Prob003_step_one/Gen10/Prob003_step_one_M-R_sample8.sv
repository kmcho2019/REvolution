module TopModule(output reg one);
    always @(*) begin
        one = 1'b1; // Constantly drive output to logic high
    end
endmodule