module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Memory array for 4 entries, 4 bits each
    reg [3:0] stack_mem [3:0];

    // 2-bit pointer for top index in circular buffer (0 to 3)
    reg [1:0] top_idx;

    // Count of entries in the buffer (0=empty, 4=full)
    reg [2:0] count;

    // Next pointer and count values
    reg [1:0] next_top_idx;
    reg [2:0] next_count;

    // Push and pop operations determined by RW and EN and buffer status
    wire push = EN && (RW == 1'b0) && (count != 3'd4);
    wire pop  = EN && (RW == 1'b1) && (count != 3'd0);

    // Circular increment and decrement helpers
    function [1:0] incr_ptr;
        input [1:0] ptr;
        begin
            incr_ptr = (ptr == 2'd3) ? 2'd0 : ptr + 2'd1;
        end
    endfunction

    function [1:0] decr_ptr;
        input [1:0] ptr;
        begin
            decr_ptr = (ptr == 2'd0) ? 2'd3 : ptr - 2'd1;
        end
    endfunction

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear memory, pointer, count, output
            top_idx <= 2'd0;
            count <= 3'd0;
            dataOut <= 4'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (push && pop) begin
            // Simultaneous push and pop: no count change, pointer moves forward (push) then backward (pop), net no change.
            // So pointer and count unchanged.
            // Push at next position, pop from current top.
            // Here, implement push and pop logically:
            // Push: write dataIn at next_top_idx (incr_ptr(top_idx))
            // Pop: output data at top_idx (current top)
            dataOut <= stack_mem[top_idx];
            stack_mem[incr_ptr(top_idx)] <= dataIn;
            // No pointer or count update needed
        end else if (push) begin
            // Push only
            next_top_idx = incr_ptr(top_idx);
            top_idx <= next_top_idx;
            count <= count + 3'd1;
            stack_mem[next_top_idx] <= dataIn;
            // dataOut unchanged
        end else if (pop) begin
            // Pop only
            dataOut <= stack_mem[top_idx];
            top_idx <= decr_ptr(top_idx);
            count <= count - 3'd1;
            // stack_mem[top_idx] not cleared to save power
        end
        // If no operation or EN=0, hold all registers
    end

    // Flags combinational
    assign EMPTY = (count == 3'd0);
    assign FULL  = (count == 3'd4);

endmodule