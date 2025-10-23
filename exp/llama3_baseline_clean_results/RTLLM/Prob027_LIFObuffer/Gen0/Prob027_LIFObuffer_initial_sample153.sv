module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // stack memory array
reg [1:0] SP; // stack pointer

// initialize stack pointer and flags
initial begin
    SP = 4'd4;
    EMPTY = 1'b1;
    FULL = 1'b0;
end

always @ (posedge Clk) begin
    if (Rst) begin
        // reset stack memory and pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 4'd4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (~RW && (SP > 4'd0)) begin
            // push data onto stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
            if (SP == 4'd0) begin
                FULL <= 1'b1;
            end
            EMPTY <= 1'b0;
        end else if (RW && (SP < 4'd4)) begin
            // pop data from stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
            if (SP == 4'd4) begin
                EMPTY <= 1'b1;
            end
            FULL <= 1'b0;
        end
    end
end

endmodule