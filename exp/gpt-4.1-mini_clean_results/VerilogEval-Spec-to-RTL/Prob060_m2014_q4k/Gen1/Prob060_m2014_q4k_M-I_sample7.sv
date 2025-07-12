module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg dff0, dff1, dff2, dff3;

    always @(posedge clk) begin
        if (~resetn) begin
            dff0 <= 1'b0;
            dff1 <= 1'b0;
            dff2 <= 1'b0;
            dff3 <= 1'b0;
        end else begin
            dff0 <= in;
            dff1 <= dff0;
            dff2 <= dff1;
            dff3 <= dff2;
        end
    end

    assign out = dff3;

endmodule