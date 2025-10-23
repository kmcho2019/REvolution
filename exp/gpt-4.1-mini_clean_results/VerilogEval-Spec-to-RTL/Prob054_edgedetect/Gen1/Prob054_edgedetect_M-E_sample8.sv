module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] stage1;
    reg [7:0] stage2;

    always @(posedge clk) begin
        stage1 <= in;
        stage2 <= stage1;
        // Detect rising edge on previous cycle: stage2==0 and stage1==1
        pedge <= (~stage2) & stage1;
    end

endmodule