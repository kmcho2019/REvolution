module TopModule (
    input         clk,
    input  [7:0]  in,
    output        parity
);

    reg [7:0] in_reg;

    always @(posedge clk) begin
        in_reg <= in;
    end

    assign parity = ^in_reg;

endmodule