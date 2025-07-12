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

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Head and tail pointers (2 bits each)
    reg [1:0] head_ptr;
    reg [1:0] tail_ptr;

    // Combinational flag logic
    always @(*) begin
        EMPTY = (head_ptr == tail_ptr);
        FULL = ((head_ptr + 1) % 4 == tail_ptr);
    end

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            head_ptr <= 2'd0;
            tail_ptr <= 2'd0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[head_ptr] <= dataIn;
                head_ptr <= (head_ptr + 1) % 4;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[(head_ptr - 1) % 4];
                head_ptr <= (head_ptr - 1) % 4;
            end
        end
    end

endmodule