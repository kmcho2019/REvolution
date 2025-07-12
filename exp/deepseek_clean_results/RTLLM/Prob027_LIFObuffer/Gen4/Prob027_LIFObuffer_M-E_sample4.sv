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
    reg [3:0] buffer_mem [0:3];
    reg [1:0] w_ptr, r_ptr;  // 2-bit pointers for 4-entry buffer
    reg [1:0] count;         // Track number of valid entries
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and flags
            w_ptr <= 2'b00;
            r_ptr <= 2'b00;
            count <= 2'b00;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b000: begin  // Write when not full
                    buffer_mem[w_ptr] <= dataIn;
                    w_ptr <= w_ptr + 1;
                    count <= count + 1;
                    EMPTY <= 1'b0;
                    FULL <= (count == 2'd3);
                end
                3'b100: begin  // Read when not empty
                    dataOut <= buffer_mem[r_ptr];
                    r_ptr <= r_ptr + 1;
                    count <= count - 1;
                    FULL <= 1'b0;
                    EMPTY <= (count == 2'd1);
                end
                default: ;  // No operation
            endcase
        end
    end

endmodule