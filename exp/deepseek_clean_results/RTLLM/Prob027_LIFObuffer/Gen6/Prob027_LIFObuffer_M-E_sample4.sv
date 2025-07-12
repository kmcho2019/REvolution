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

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Head pointer (write) and tail pointer (read)
    reg [1:0] head_ptr, tail_ptr;
    // Operation valid signals
    wire write_op = EN && !RW;
    wire read_op = EN && RW;
    
    // Flag generation (combinational)
    always @(*) begin
        FULL = ((head_ptr + 2'd1) == tail_ptr) || 
              ((head_ptr == 2'd3) && (tail_ptr == 2'd0));
        EMPTY = (head_ptr == tail_ptr);
    end

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            head_ptr <= 2'd0;
            tail_ptr <= 2'd0;
            dataOut <= 4'b0;
        end
        else begin
            // Write operation (push) - higher priority than read
            if (write_op && !FULL) begin
                stack_mem[head_ptr] <= dataIn;
                head_ptr <= (head_ptr == 2'd3) ? 2'd0 : head_ptr + 1;
            end
            // Read operation (pop)
            else if (read_op && !EMPTY) begin
                dataOut <= stack_mem[tail_ptr];
                tail_ptr <= (tail_ptr == 2'd3) ? 2'd0 : tail_ptr + 1;
            end
        end
    end

endmodule