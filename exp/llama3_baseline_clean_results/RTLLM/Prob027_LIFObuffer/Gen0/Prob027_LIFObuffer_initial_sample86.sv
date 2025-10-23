module LIFObuffer(
    input [3:0] dataIn,
    input RW, EN, Rst, Clk,
    output reg EMPTY, FULL,
    output reg [3:0] dataOut
);

// Initialize stack size
localparam STACK_SIZE = 4;

// Define stack memory
reg [3:0] stack_mem[STACK_SIZE-1:0];

// Define stack pointer
reg [1:0] SP;

// Initialize flags and data output
always @(posedge Clk) begin
    if (Rst) begin
        // Reset stack and initialize stack pointer
        for (int i = 0; i < STACK_SIZE; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'b0;
    end else if (EN) begin
        // Check if buffer is empty or full
        EMPTY <= (SP == 4);
        FULL <= (SP == 0);
        
        if (RW == 1'b0 && !FULL) begin
            // Push data onto stack
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1'b1 && !EMPTY) begin
            // Pop data from stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

endmodule