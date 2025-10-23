module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg d0, d1, d2, d3;
    
    always @(posedge clk) begin
        if (!resetn) begin
            d0 <= 1'b0;
            d1 <= 1'b0;
            d2 <= 1'b0;
            d3 <= 1'b0;
        end else begin
            d0 <= in;
            d1 <= d0;
            d2 <= d1;
            d3 <= d2;
        end
    end
    
    assign out = d3;

endmodule