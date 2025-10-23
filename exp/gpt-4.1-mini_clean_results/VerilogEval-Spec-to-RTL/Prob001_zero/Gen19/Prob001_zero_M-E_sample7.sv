module TopModule(output reg zero, input clk);
    initial zero = 1'b0;
    always @(posedge clk) begin
        zero <= 1'b0;
    end
endmodule