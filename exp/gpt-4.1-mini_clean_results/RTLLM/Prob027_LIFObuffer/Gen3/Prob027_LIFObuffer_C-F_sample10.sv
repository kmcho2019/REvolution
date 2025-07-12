module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,        // Active high synchronous reset
    input  wire        EN,
    input  wire        RW,         // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries of 4-bit width
    reg [3:0] stack_mem [3:0];
    // Stack pointer: points to next free slot; 0 = empty, 4 = full
    reg [2:0] SP;

    integer i;

    // Synchronous reset of stack_mem (separate block for clarity and tool friendliness)
    always @(posedge Clk) begin
        if (Rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end
    end

    // Sequential logic for SP, stack_mem updates, and dataOut
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;            // Empty stack
            dataOut <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation: if not full, write and increment SP
                if (SP != 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else full: do nothing
            end else begin
                // Pop operation: if not empty, decrement SP then read dataOut
                if (SP != 3'd0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                end
                // else empty: do nothing (dataOut unchanged)
            end
        end
        // If EN is low, hold SP and dataOut steady (no operation)
    end

    // Combinational flags for EMPTY and FULL based on SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule