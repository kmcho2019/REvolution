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

    // Internal circular buffer (4 entries of 4 bits each)
    reg [3:0] buffer_mem [0:3];
    // Head pointer (write position), Tail pointer (read position)
    reg [1:0] head_ptr, tail_ptr;

    // Combinational flag assignments
    assign EMPTY = (head_ptr == tail_ptr);
    assign FULL = ((head_ptr + 1) % 4 == tail_ptr);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset pointers only (memory retains values for power efficiency)
            head_ptr <= 2'b00;
            tail_ptr <= 2'b00;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b000: begin  // Write operation, not full
                    buffer_mem[head_ptr] <= dataIn;
                    head_ptr <= (head_ptr + 1) % 4;
                end
                3'b100: begin  // Read operation, not empty
                    dataOut <= buffer_mem[tail_ptr];
                    tail_ptr <= (tail_ptr + 1) % 4;
                end
                // Other cases are no-ops (write when full or read when empty)
                default: ;
            endcase
        end
    end

endmodule