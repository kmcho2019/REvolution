module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,           // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: counts number of entries in stack (0 to 4)
    reg [2:0] SP;

    // EMPTY when SP == 0; FULL when SP == 4
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Clear stack memory on reset
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation: if not full
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                    // dataOut unchanged on push
                end
            end else begin
                // Pop operation: if not empty
                if (SP > 0) begin
                    // Decrement SP first
                    SP <= SP - 1;
                    // Output data from top of stack (after decrement)
                    dataOut <= stack_mem[SP - 1];
                    // Do not clear stack_mem[SP-1] to reduce switching
                end
                // else no pop, dataOut retains last value
            end
        end
        // else EN low: no operation, state holds
    end

endmodule