module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write(push), 1: read(pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);
    // Stack memory: 4 entries of 4-bit width
    reg [3:0] stack_mem [3:0];

    // Stack pointer: counts number of stored entries, 0 to 4
    reg [2:0] SP;
    reg [2:0] read_addr;

    // Derived push and pop enables
    wire push_en  = EN & ~RW & (~FULL);
    wire pop_en   = EN & RW & (~EMPTY);

    // Flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            read_addr <= 3'd0;
            // stack_mem not cleared for power saving
        end else begin
            if (push_en) begin
                stack_mem[SP] <= dataIn;   // Write data at current SP location
                SP <= SP + 1'b1;           // Increment SP
            end else if (pop_en) begin
                read_addr <= SP - 1'b1;    // Capture address to read
                SP <= SP - 1'b1;           // Decrement SP
            end

            // Output data from memory at captured read_addr
            // DataOut updated in next cycle after pop_en to avoid combinational read delay
            if (pop_en) begin
                dataOut <= stack_mem[SP - 1];
            end
        end
    end
endmodule