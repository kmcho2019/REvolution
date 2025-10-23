module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Each stage consists of data and valid bit
    reg [3:0] stage0, stage1, stage2, stage3;
    reg valid0, valid1, valid2, valid3;

    // Combinational flag generation
    assign EMPTY = ~(valid0 | valid1 | valid2 | valid3);
    assign FULL = valid0 & valid1 & valid2 & valid3;

    always @(posedge Clk) begin
        if (Rst) begin
            // Clear all stages and valid bits
            {stage0, stage1, stage2, stage3} <= 0;
            {valid0, valid1, valid2, valid3} <= 0;
            dataOut <= 0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Push operation - shift down and insert at top
                stage3 <= stage2;
                stage2 <= stage1;
                stage1 <= stage0;
                stage0 <= dataIn;
                valid3 <= valid2;
                valid2 <= valid1;
                valid1 <= valid0;
                valid0 <= 1'b1;
            end
            else if (RW && !EMPTY) begin
                // Pop operation - extract top and shift up
                dataOut <= stage0;
                stage0 <= stage1;
                stage1 <= stage2;
                stage2 <= stage3;
                stage3 <= 0;  // Optional clear
                valid0 <= valid1;
                valid1 <= valid2;
                valid2 <= valid3;
                valid3 <= 1'b0;
            end
        end
    end

endmodule