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

    // Circular buffer memory (4 entries)
    reg [3:0] buffer_mem [0:3];
    
    // Head and tail pointers (2 bits each)
    reg [1:0] head_ptr;  // Points to next write location
    reg [1:0] tail_ptr;  // Points to next read location
    
    // Pre-fetch register
    reg [3:0] next_data;
    reg has_next;

    // Combinational flag assignments
    assign EMPTY = (head_ptr == tail_ptr) && !has_next;
    assign FULL = ((head_ptr + 1) == tail_ptr) || 
                 (head_ptr == 2'b11 && tail_ptr == 2'b00);

    // Pointer and memory control logic
    always @(posedge Clk) begin
        if (Rst) begin
            head_ptr <= 2'b00;
            tail_ptr <= 2'b00;
            dataOut <= 4'b0;
            next_data <= 4'b0;
            has_next <= 1'b0;
        end
        else if (EN) begin
            // Write operation (push)
            if (!RW && !FULL) begin
                buffer_mem[head_ptr] <= dataIn;
                head_ptr <= head_ptr + 1;
                // Clear pre-fetch on push
                has_next <= 1'b0;
            end
            // Read operation (pop)
            else if (RW && !EMPTY) begin
                if (has_next) begin
                    // Use pre-fetched value
                    dataOut <= next_data;
                    has_next <= 1'b0;
                    tail_ptr <= tail_ptr + 1;
                end
                else begin
                    // Direct read and pre-fetch next
                    dataOut <= buffer_mem[tail_ptr];
                    if ((tail_ptr + 1) != head_ptr) begin
                        next_data <= buffer_mem[tail_ptr + 1];
                        has_next <= 1'b1;
                    end
                    tail_ptr <= tail_ptr + 1;
                end
            end
        end
    end

endmodule