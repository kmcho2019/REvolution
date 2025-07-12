module TopModule (
    input clk,
    input a,
    output reg q
);

    always @(posedge clk) begin
        q <= ~a;  // register the inverted input directly into output q
    end

endmodule