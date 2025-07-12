module TopModule(input clk, input a, output reg q);
    wire d = ~a;
    
    always @(posedge clk) begin
        q <= d;
    end
endmodule