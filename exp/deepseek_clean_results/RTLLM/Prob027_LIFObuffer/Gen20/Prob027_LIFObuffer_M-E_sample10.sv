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
    reg [1:0] head, tail;
    // Count of valid entries
    reg [2:0] count;

    // Combinational flag assignments
    assign EMPTY = (count == 0);
    assign FULL = (count == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and count
            head <= 0;
            tail <= 0;
            count <= 0;
            dataOut <= 0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b0_0_x: begin // Write when not full
                    stack_mem[head] <= dataIn;
                    head <= (head == 3) ? 0 : head + 1;
                    count <= count + 1;
                end
                3'b1_x_0: begin // Read when not empty
                    dataOut <= stack_mem[tail];
                    tail <= (tail == 3) ? 0 : tail + 1;
                    count <= count - 1;
                end
                default: ; // No operation
            endcase
        end
    end

endmodule