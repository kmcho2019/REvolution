module LIFObuffer(
    input   wire    [3:0]  dataIn,   // 4-bit input data
    input   wire             RW,      // Read/Write control signal (1 for read, 0 for write)
    input   wire             EN,      // Enable signal
    input   wire             Rst,     // Active high reset signal
    input   wire             Clk,     // Clock signal
    output  reg      [3:0]  dataOut, // 4-bit output data
    output  reg              EMPTY,  // Flag indicating whether the buffer is empty
    output  reg              FULL    // Flag indicating whether the buffer is full
);

    reg [3:0] stack_mem [0:3]; // stack memory array
    reg [1:0] SP;             // stack pointer

    // initialize stack pointer and flags
    initial begin
        SP = 4'd4;
        EMPTY = 1'b1;
        FULL = 1'b0;
    end

    // update flags based on stack pointer
    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // reset buffer
                for (int i = 0; i < 4; i++) begin
                    stack_mem[i] <= 4'd0;
                end
                SP <= 4'd4;
                EMPTY <= 1'b1;
                FULL <= 1'b0;
            end else begin
                // update flags
                if (SP == 4'd4) begin
                    EMPTY <= 1'b1;
                end else begin
                    EMPTY <= 1'b0;
                end

                if (SP == 4'd0) begin
                    FULL <= 1'b1;
                end else begin
                    FULL <= 1'b0;
                end

                // process data
                if (RW == 1'b0 && ~FULL) begin
                    // push data onto stack
                    stack_mem[SP - 1] <= dataIn;
                    SP <= SP - 1;
                end else if (RW == 1'b1 && ~EMPTY) begin
                    // pop data from stack
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1;
                end
            end
        end
    end
endmodule