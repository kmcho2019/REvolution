module TopModule(
    output reg out
);
    initial begin
        out = 1'b0;
    end
    always @(*) begin
        // output remains zero continuously
        out = 1'b0;
    end
endmodule