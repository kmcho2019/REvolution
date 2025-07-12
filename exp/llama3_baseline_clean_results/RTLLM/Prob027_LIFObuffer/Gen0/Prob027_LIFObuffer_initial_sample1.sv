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

reg [3:0] stack_mem [0:3];
reg [1:0] SP;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end
    else if (EN) begin
        // Handle push operation
        if (!RW && SP != 0) begin
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end
        // Handle pop operation
        else if (RW && SP != 4) begin
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end

    // Update EMPTY and FULL flags
    if (SP == 4) begin
        EMPTY <= 1'b1;
    end
    else begin
        EMPTY <= 1'b0;
    end

    if (SP == 0) begin
        FULL <= 1'b1;
    end
    else begin
        FULL <= 1'b0;
    end
end

endmodule