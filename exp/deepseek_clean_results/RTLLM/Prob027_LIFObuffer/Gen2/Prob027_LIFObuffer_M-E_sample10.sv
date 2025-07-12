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

    // Internal stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Head and tail pointers (2 bits each for 4 locations)
    reg [1:0] head_ptr;
    reg [1:0] tail_ptr;
    // Entry counter (3 bits to count 0-4)
    reg [2:0] count;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            head_ptr <= 2'b11;  // Initialize to last position
            tail_ptr <= 2'b11;
            count <= 3'b0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            // Clear stack memory
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[head_ptr] <= dataIn;
                // Move head pointer backward with wrap-around
                head_ptr <= (head_ptr == 2'b00) ? 2'b11 : head_ptr - 1;
                count <= count + 1;
                // Update flags
                EMPTY <= 1'b0;
                FULL <= (count == 3'b011) ? 1'b1 : 1'b0;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                // First increment head pointer (since it points to next empty)
                head_ptr <= (head_ptr == 2'b11) ? 2'b00 : head_ptr + 1;
                dataOut <= stack_mem[head_ptr];
                count <= count - 1;
                // Update flags
                FULL <= 1'b0;
                EMPTY <= (count == 3'b001) ? 1'b1 : 1'b0;
            end
        end
    end

    // Alternative flag generation (combinational)
    // always @(*) begin
    //     EMPTY = (count == 0);
    //     FULL = (count == 4);
    // end

endmodule