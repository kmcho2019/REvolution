module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP):
    // SP counts number of valid entries: 0 (empty) to 4 (full).
    reg [2:0] SP; // 3-bit counter from 0 to 4

    // Push and pop operation detection
    wire push_op = EN && (RW == 1'b0) && (SP != 3'd4);
    wire pop_op  = EN && (RW == 1'b1) && (SP != 3'd0);
    wire valid_op = push_op || pop_op;

    integer i;

    // Clock gating signals for memory write and dataOut update
    wire clk_stack_mem_en = push_op;
    wire clk_dataOut_en = pop_op;

    // Use gated clocks for stack_mem and dataOut to reduce toggling
    reg clk_stack_mem_en_d;
    reg clk_dataOut_en_d;

    always @(posedge Clk) begin
        clk_stack_mem_en_d <= clk_stack_mem_en;
        clk_dataOut_en_d <= clk_dataOut_en;
    end

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack pointer and output
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Initialize stack memory to 0
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            if (push_op) begin
                // Push dataIn to stack_mem[SP], increment SP
                SP <= SP + 3'd1;
                stack_mem[SP] <= dataIn;
                // dataOut unchanged
            end else if (pop_op) begin
                // Pop operation: decrement SP, then output top data
                SP <= SP - 3'd1;
                // Read stack_mem[SP - 1] before decrement
                dataOut <= stack_mem[SP - 3'd1];
                // Do not clear stack_mem on pop for power saving
            end else begin
                // No change to SP or dataOut if no valid operation
                SP <= SP;
                dataOut <= dataOut;
            end
        end
    end

    // Flags combinational from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule