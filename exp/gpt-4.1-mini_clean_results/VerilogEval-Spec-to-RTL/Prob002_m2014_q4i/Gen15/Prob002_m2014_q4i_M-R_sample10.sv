module TopModule(
    output reg out
);
    // Use always_comb block to drive output to zero continuously
    always @(*) begin
        out = 1'b0;
    end
endmodule