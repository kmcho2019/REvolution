module TopModule (
    input clk,
    input in,
    output out
);

    reg q;
    wire d;
    
    assign d = in ^ q;
    assign out = q;

    always @(posedge clk) begin
        q <= d;
    end

endmodule