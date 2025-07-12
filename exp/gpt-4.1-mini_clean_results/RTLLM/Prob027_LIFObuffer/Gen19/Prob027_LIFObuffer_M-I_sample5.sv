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
    // Counts number of valid entries in stack: 0 = empty, 4 = full
    reg [2:0] SP; // range: 0..4

    // Registered read pointer for pop operation to pipeline dataOut update
    reg [2:0] read_ptr;

    // Push and pop conditions
    wire push_op = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_op  = EN && (RW == 1'b1) && (SP > 3'd0);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            read_ptr <= 3'd0;
            // Clear entire stack memory
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (push_op) begin
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
            end else if (pop_op) begin
                SP <= SP - 3'd1;
                read_ptr <= SP - 3'd1; // Register pointer for next dataOut update
            end

            // Update dataOut with the registered read_ptr value
            // Only valid when pop_op was asserted previously (so SP and read_ptr valid)
            if (pop_op || (!push_op && !pop_op && SP > 0)) begin
                // dataOut holds last popped value or stable when no operations
                dataOut <= stack_mem[read_ptr];
            end
            else if (push_op && !(pop_op)) begin
                // On push only, maintain current dataOut (no pop)
                // Or optionally keep dataOut unchanged
                dataOut <= dataOut;
            end
            // When empty and no operations, dataOut stays 0 (from reset)
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule