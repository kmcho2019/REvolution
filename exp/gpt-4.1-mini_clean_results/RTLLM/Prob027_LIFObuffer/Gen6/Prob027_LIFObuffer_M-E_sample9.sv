module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,     // active high reset
    input  wire       EN,      // enable
    input  wire       RW,      // 0 = write (push), 1 = read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries x 4 bits
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: signed 3-bit, -1 means empty, 0..3 valid indices
    reg signed [2:0] SP;

    integer i;

    // Synchronous stack pointer and memory update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= -1;           // empty state
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i +1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP < 3) begin
                    SP <= SP + 1;
                    stack_mem[SP + 1] <= dataIn;
                end
                // else full, do nothing
            end else begin
                // Read (pop)
                if (SP >= 0) begin
                    dataOut <= stack_mem[SP];
                    // Clear the popped position optionally
                    // stack_mem[SP] <= 4'd0; // optional, can skip to reduce toggling
                    SP <= SP - 1;
                end else begin
                    // Empty, output remains unchanged or zero
                    dataOut <= dataOut;
                end
            end
        end
    end

    // Combinational flags
    assign EMPTY = (SP == -1);
    assign FULL  = (SP == 3);

endmodule