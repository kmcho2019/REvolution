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

    // Circular buffer implementation
    reg [3:0] buffer [0:3];
    reg [1:0] head_ptr;  // Points to next write location
    reg [1:0] tail_ptr;  // Points to next read location
    reg [1:0] count;     // Tracks number of valid entries
    reg last_op;         // 0=write, 1=read (tracks last operation)

    // Flag logic
    assign EMPTY = (count == 0);
    assign FULL = (count == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and clear count
            head_ptr <= 0;
            tail_ptr <= 0;
            count <= 0;
            last_op <= 0;
            dataOut <= 0;
        end
        else if (EN) begin
            case ({RW, EMPTY, FULL})
                3'b000: begin // Write when not full
                    buffer[head_ptr] <= dataIn;
                    head_ptr <= (head_ptr == 3) ? 0 : head_ptr + 1;
                    count <= count + 1;
                    last_op <= 0;
                end
                3'b010: begin // Read when not empty
                    dataOut <= buffer[(tail_ptr == 0) ? 3 : tail_ptr - 1];
                    if (last_op) begin
                        tail_ptr <= (tail_ptr == 0) ? 3 : tail_ptr - 1;
                    end
                    count <= count - 1;
                    last_op <= 1;
                end
                default: ; // No operation
            endcase
        end
    end

    // Virtual stack behavior:
    // - Push: Write to head, increment head
    // - Pop: Read from head-1, decrement head
    // - Last operation tracking ensures correct pointer movement
    // - Count tracks actual entries for flag generation

endmodule