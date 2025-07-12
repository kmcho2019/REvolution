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

    reg [3:0] buffer_mem [0:3];  // Circular buffer memory
    reg [1:0] head_ptr;          // Points to next write location
    reg [1:0] tail_ptr;          // Points to next read location
    reg [1:0] count;             // Tracks number of valid entries

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: initialize pointers and flags
            head_ptr <= 2'd3;    // Start at last position
            tail_ptr <= 2'd0;
            count <= 2'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                buffer_mem[head_ptr] <= dataIn;
                head_ptr <= (head_ptr == 2'd0) ? 2'd3 : head_ptr - 1;
                count <= count + 1;
                EMPTY <= 1'b0;
                FULL <= (count == 2'd3) ? 1'b1 : 1'b0;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= buffer_mem[(head_ptr + 1) % 4];
                head_ptr <= (head_ptr + 1) % 4;
                count <= count - 1;
                FULL <= 1'b0;
                EMPTY <= (count == 2'd1) ? 1'b1 : 1'b0;
            end
        end
    end

endmodule