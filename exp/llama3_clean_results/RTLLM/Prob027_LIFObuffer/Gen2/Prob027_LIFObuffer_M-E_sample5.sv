module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

// Array of registers to mimic a shift register
reg [3:0] stage1, stage2, stage3, stage4;

// Flags to indicate buffer status
reg EMPTY, FULL;

// Combinational logic to update flags
assign EMPTY = (!stage1 && !stage2 && !stage3 && !stage4);
assign FULL = (stage1 && stage2 && stage3 && stage4);

// Sequential logic to handle push and pop operations
always @(posedge Clk) begin
    if (Rst) begin
        // Reset all stages and flags
        stage1 <= 4'b0;
        stage2 <= 4'b0;
        stage3 <= 4'b0;
        stage4 <= 4'b0;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'b0;
    end else if (EN) begin
        if (!RW && !FULL) begin
            // Push data onto the buffer (shift existing data)
            stage4 <= stage3;
            stage3 <= stage2;
            stage2 <= stage1;
            stage1 <= dataIn;
        end else if (RW && !EMPTY) begin
            // Pop data from the buffer (shift data back)
            dataOut <= stage4;
            stage4 <= stage3;
            stage3 <= stage2;
            stage2 <= stage1;
            stage1 <= 4'b0;
        end
    end
end

endmodule