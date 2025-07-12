module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,        // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];

    // Stack pointer points to next free slot for push or top element for pop
    reg [1:0] ptr;  // 2-bit pointer (0 to 3)
    reg [2:0] count; // number of elements in stack (0 to 4)

    wire push_en = EN & (RW == 1'b0) & (count < 3'd4);
    wire pop_en  = EN & (RW == 1'b1) & (count > 3'd0);

    assign EMPTY = (count == 3'd0);
    assign FULL  = (count == 3'd4);

    // Calculate address for pop: pointer is next free slot, so top element is ptr - 1 (wrapping)
    wire [1:0] pop_addr = (ptr == 2'd0) ? 2'd3 : (ptr - 2'd1);

    integer i;
    always @(posedge Clk) begin
        if (Rst) begin
            ptr <= 2'd0;
            count <= 3'd0;
            dataOut <= 4'd0;
            // Clear memory locations on reset for defined state
            for (i=0; i<4; i=i+1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (push_en) begin
                // Write dataIn at ptr location, increment ptr and count
                stack_mem[ptr] <= dataIn;
                ptr <= ptr + 2'd1; // wrap-around automatically by 2-bit width
                count <= count + 3'd1;
                // dataOut unchanged on push to minimize toggling
            end else if (pop_en) begin
                // Decrement ptr, decrement count, update dataOut with popped data
                ptr <= pop_addr;
                count <= count - 3'd1;
                dataOut <= stack_mem[pop_addr];
                // Do not clear memory to reduce toggling
            end
            // else: no operation
        end
    end

endmodule