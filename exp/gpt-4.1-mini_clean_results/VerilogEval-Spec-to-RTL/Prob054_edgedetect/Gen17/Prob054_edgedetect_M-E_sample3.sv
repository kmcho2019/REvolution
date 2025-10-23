module TopModule (
    input          clk,
    input  [7:0]   in,
    output reg [7:0] pedge
);

    reg [7:0] stage1;
    reg [7:0] stage2;

    always @(posedge clk) begin
        stage1 <= in;
        stage2 <= stage1;
        pedge  <= (~stage2) & stage1;
    end

endmodule