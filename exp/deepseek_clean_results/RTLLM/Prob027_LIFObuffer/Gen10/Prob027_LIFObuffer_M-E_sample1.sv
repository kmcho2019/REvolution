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
    reg [1:0] write_ptr;  // Points to next write location
    reg [1:0] read_ptr;   // Points to next read location
    reg [2:0] count;      // Tracks number of valid entries (0-4)

    // Flag assignments
    assign EMPTY = (count == 0);
    assign FULL = (count == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and counter
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            dataOut <= 0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b000: begin // Write operation, not full
                    buffer[write_ptr] <= dataIn;
                    write_ptr <= write_ptr + 1;
                    count <= count + 1;
                end
                3'b100: begin // Read operation, not empty
                    // Read from previous position (LIFO behavior)
                    dataOut <= buffer[(write_ptr - 1) % 4];
                    write_ptr <= write_ptr - 1;
                    count <= count - 1;
                end
                default: begin // No operation or invalid conditions
                    // Maintain current state
                end
            endcase
        end
    end

    // Initialize all buffer locations to zero (optional)
    integer i;
    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            buffer[i] = 0;
        end
    end

endmodule