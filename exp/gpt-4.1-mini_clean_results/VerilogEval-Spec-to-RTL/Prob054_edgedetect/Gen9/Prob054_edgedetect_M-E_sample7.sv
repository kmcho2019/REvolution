module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    // 2-stage shift register to hold current and previous inputs
    reg [7:0] shift_reg [1:0];

    always @(posedge clk) begin
        // Shift the previous input samples
        shift_reg[0] <= in;
        shift_reg[1] <= shift_reg[0];

        // pedge is set when previous stage was 0 and current stage is 1 (0->1 transition)
        pedge <= (~shift_reg[1]) & shift_reg[0];
    end

endmodule