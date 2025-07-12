module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Internal memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Read and write pointers (2 bits each for 4 locations)
    reg [1:0] w_ptr, r_ptr;
    
    // Counter for number of elements (3 bits to count 0-4)
    reg [2:0] count;
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            w_ptr <= 2'd0;
            r_ptr <= 2'd0;
            count <= 3'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[w_ptr] <= dataIn;
                w_ptr <= w_ptr + 1;
                count <= count + 1;
                
                // Update flags
                EMPTY <= 1'b0;
                FULL <= (count == 3'd3);
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                // Move read pointer first (LIFO behavior)
                r_ptr <= w_ptr - 1;
                dataOut <= stack_mem[w_ptr - 1];
                w_ptr <= w_ptr - 1;
                count <= count - 1;
                
                // Update flags
                FULL <= 1'b0;
                EMPTY <= (count == 3'd1);
            end
        end
    end
    
    // Initialize all memory locations to zero
    integer i;
    initial begin
        for (i = 0; i < 4; i = i + 1)
            stack_mem[i] = 4'b0;
    end
    
endmodule