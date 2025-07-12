module TopModule (
    input clk,
    input in,
    output out
);

    reg q;
    wire d = in ^ q;
    
    assign out = q;
    
    always @(posedge clk) begin
        q <= d;
    end

endmodule