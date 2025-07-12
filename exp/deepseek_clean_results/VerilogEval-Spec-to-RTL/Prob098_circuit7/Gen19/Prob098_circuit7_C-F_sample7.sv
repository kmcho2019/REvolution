module TopModule(input clk, input a, output reg q);
    // Sequential block with inverted input
    always @(posedge clk) begin
        q <= ~a;  // Inverted input directly assigned to flop
    end
endmodule