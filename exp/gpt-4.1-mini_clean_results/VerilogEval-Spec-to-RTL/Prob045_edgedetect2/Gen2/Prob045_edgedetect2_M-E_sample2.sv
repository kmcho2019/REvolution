module TopModule(
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] reg_stage1;
    reg [7:0] reg_stage2;

    always @(posedge clk) begin
        reg_stage1 <= in;                   // sample current input
        reg_stage2 <= reg_stage1;           // delay input by one cycle
        anyedge <= reg_stage1 ^ reg_stage2; // edge detected at previous cycle, output delayed by one clock
    end

endmodule