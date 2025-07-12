module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] stage1, stage2;

    always @(posedge clk) begin
        stage1 <= in;                    // store current input
        stage2 <= stage1;                // store previous input value (delayed 1 cycle)
        anyedge <= (stage1 ^ stage2);   // edge detected one cycle after transition
    end
endmodule