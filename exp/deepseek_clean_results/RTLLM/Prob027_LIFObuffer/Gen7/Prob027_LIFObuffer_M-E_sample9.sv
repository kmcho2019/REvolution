module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries, each 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Head pointer (next write position)
    reg [1:0] head;
    
    // Tail pointer (next read position)
    reg [1:0] tail;
    
    // Status flags (combinational for better timing)
    assign EMPTY = (head == tail) && !FULL;
    assign FULL = ((head + 1) % 4) == tail;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: clear pointers and memory
            head <= 2'd0;
            tail <= 2'd0;
            dataOut <= 4'b0;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[head] <= dataIn;
                head <= (head + 1) % 4;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                // Need to read from previous head position
                dataOut <= stack_mem[(head + 3) % 4];
                head <= (head + 3) % 4; // Equivalent to head - 1 mod 4
            end
        end
    end

endmodule