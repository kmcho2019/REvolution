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

    // Stack memory (4 entries of 4 bits)
    reg [3:0] stack_mem [0:3];
    // Head pointer (write) and tail pointer (read)
    reg [1:0] head_ptr, tail_ptr;
    // Entry count for full/empty detection
    reg [2:0] entry_count;
    
    // Output register pipeline
    reg [3:0] dataOut_next;

    // Combinational flag assignments
    assign EMPTY = (entry_count == 0);
    assign FULL = (entry_count == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and clear output
            head_ptr <= 0;
            tail_ptr <= 0;
            entry_count <= 0;
            dataOut <= 0;
            dataOut_next <= 0;
        end
        else if (EN) begin
            // Handle write operation (push)
            if (!RW && !FULL) begin
                stack_mem[head_ptr] <= dataIn;
                head_ptr <= (head_ptr == 3) ? 0 : head_ptr + 1;
                entry_count <= entry_count + 1;
            end
            // Handle read operation (pop)
            else if (RW && !EMPTY) begin
                dataOut_next <= stack_mem[tail_ptr];
                tail_ptr <= (tail_ptr == 3) ? 0 : tail_ptr + 1;
                entry_count <= entry_count - 1;
            end
        end
        
        // Pipeline stage for output
        dataOut <= dataOut_next;
    end

    // Initialize all memory locations to zero
    integer i;
    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            stack_mem[i] = 0;
        end
    end

endmodule