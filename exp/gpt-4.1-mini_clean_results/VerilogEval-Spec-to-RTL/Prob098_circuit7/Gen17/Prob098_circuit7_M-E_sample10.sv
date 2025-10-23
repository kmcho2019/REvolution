module TopModule (
    input clk,
    input a,
    output q
);
    reg stored;

    always @(posedge clk) begin
        stored <= a;
    end

    assign q = ~stored;

endmodule