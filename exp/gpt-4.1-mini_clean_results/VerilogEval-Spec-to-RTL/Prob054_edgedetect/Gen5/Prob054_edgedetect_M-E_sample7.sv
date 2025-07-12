module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] stage1_in;    // first stage input register
    reg [7:0] stage2_in;    // second stage register for previous input value

    always @(posedge clk) begin
        stage1_in <= in;                       // sample input
        pedge    <= (~stage2_in) & stage1_in; // detect rising edge using delayed input
        stage2_in <= stage1_in;                // update delayed input for next cycle
    end

endmodule