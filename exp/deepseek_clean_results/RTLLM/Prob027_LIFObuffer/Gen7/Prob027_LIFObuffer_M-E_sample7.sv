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

    // Circular buffer implementation
    reg [3:0] buffer [0:3];
    reg [1:0] write_ptr, read_ptr;
    reg [2:0] count;  // Needs to count 0-4 (3 bits)
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and counters
            write_ptr <= 2'd0;
            read_ptr <= 2'd3;  // Initialize to last position for LIFO
            count <= 3'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b000: begin  // Write when not full
                    buffer[write_ptr] <= dataIn;
                    write_ptr <= write_ptr + 1;
                    read_ptr <= read_ptr;  // Hold read pointer during write
                    count <= count + 1;
                    
                    // Update flags
                    FULL <= (count == 3'd3);
                    EMPTY <= 1'b0;
                end
                3'b100: begin  // Read when not empty
                    dataOut <= buffer[read_ptr];
                    read_ptr <= read_ptr - 1;
                    write_ptr <= write_ptr;  // Hold write pointer during read
                    count <= count - 1;
                    
                    // Update flags
                    FULL <= 1'b0;
                    EMPTY <= (count == 3'd1);
                end
                default: begin  // No operation cases
                    // Maintain current state
                end
            endcase
        end
    end
    
    // Continuous assignment for flags (alternative approach)
    // assign EMPTY = (count == 0);
    // assign FULL = (count == 4);
    
endmodule