module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high asynchronous reset
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

    // Read pointer for pop data output (address of dataOut)
    reg [1:0] read_ptr;

    wire push_op = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_op  = EN && (RW == 1'b1) && (SP > 3'd0);

    // Sequential logic with asynchronous reset
    always @(posedge Clk or posedge Rst) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            read_ptr <= 2'd0;
            // stack_mem clearing omitted for area and power efficiency
        end else begin
            if (push_op) begin
                // Write dataIn at current SP index, then increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
            end else if (pop_op) begin
                // Before decrementing SP, capture read_ptr address (SP-1)
                read_ptr <= SP - 3'd1;
                SP <= SP - 3'd1;
            end

            // dataOut updated from stack_mem at read_ptr
            // Only update on pop_op to avoid glitches
            if (pop_op) begin
                dataOut <= stack_mem[read_ptr];
            end else if (!pop_op && !push_op) begin
                // Maintain previous dataOut when no operation
                dataOut <= dataOut;
            end
            // On push or reset, dataOut retains previous value except on reset above
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule