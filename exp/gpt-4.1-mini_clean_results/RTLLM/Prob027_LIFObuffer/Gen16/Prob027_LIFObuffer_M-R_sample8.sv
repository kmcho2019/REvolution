module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output reg         EMPTY,
    output reg         FULL
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP): 3 bits sufficient for 0..4
    reg [2:0] SP;

    // Combinational signals for operation detection
    wire push_op = (EN && (RW == 1'b0) && (SP != 3'd0));  // Not full and writing
    wire pop_op  = (EN && (RW == 1'b1) && (SP != 3'd4));  // Not empty and reading

    wire valid_op = push_op || pop_op;

    // Compute next stack pointer value combinationally
    wire [2:0] next_SP = push_op ? (SP - 3'd1) :
                         pop_op  ? (SP + 3'd1) :
                                   SP;

    // Generate reset pattern for stack memory elements separately
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : stack_mem_reset_block
            always_ff @(posedge Clk) begin
                if (Rst) begin
                    stack_mem[i] <= 4'd0;
                end
                else if (push_op && ((SP - 3'd1) == i)) begin
                    stack_mem[i] <= dataIn;
                end
                // No memory clearing on pop for power savings
                // No write if no push
            end
        end
    endgenerate

    // Sequential block for SP, dataOut, EMPTY, and FULL registers
    always_ff @(posedge Clk) begin
        if (Rst) begin
            SP      <= 3'd4;     // Empty state
            dataOut <= 4'd0;
            EMPTY   <= 1'b1;
            FULL    <= 1'b0;
        end else begin
            if (valid_op) begin
                SP <= next_SP;

                if (pop_op) begin
                    // Output top data during pop
                    dataOut <= stack_mem[SP];
                end
                // dataOut not updated during push or no operation
            end

            // Update flags based on next_SP if valid_op, else current SP
            if (valid_op) begin
                EMPTY <= (next_SP == 3'd4);
                FULL  <= (next_SP == 3'd0);
            end else begin
                EMPTY <= (SP == 3'd4);
                FULL  <= (SP == 3'd0);
            end
        end
    end

endmodule