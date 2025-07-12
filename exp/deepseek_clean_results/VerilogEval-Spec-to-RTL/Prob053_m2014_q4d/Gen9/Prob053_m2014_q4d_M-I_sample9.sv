module TopModule (
    input clk,
    input in,
    output out
);

    reg q = 1'b0;  // Explicit initialization to 0
    wire d;
    
    assign d = in ^ q;
    assign out = q;

    always @(posedge clk) begin
        q <= d;
    end

endmodule