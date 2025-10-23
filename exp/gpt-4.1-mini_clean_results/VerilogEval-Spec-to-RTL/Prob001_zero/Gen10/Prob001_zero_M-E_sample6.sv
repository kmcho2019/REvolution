module TopModule(output reg zero);
    wire dummy = 1'b0;

    always @(dummy) begin
        zero = 1'b0;
    end
endmodule