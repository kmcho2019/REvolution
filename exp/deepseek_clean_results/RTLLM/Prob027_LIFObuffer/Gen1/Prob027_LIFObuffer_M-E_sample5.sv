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

    reg [3:0] buffer [0:3];     // Circular buffer storage
    reg [1:0] wptr, rptr;       // Write and read pointers
    reg [2:0] count;            // Count of valid entries (0-4)

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and counters
            wptr <= 2'b00;
            rptr <= 2'b00;
            count <= 3'b000;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b000: begin  // Write when not full
                    buffer[wptr] <= dataIn;
                    wptr <= wptr + 1;
                    count <= count + 1;
                    EMPTY <= 1'b0;
                    FULL <= (count == 3'd3);
                end
                3'b100: begin  // Read when not empty
                    dataOut <= buffer[rptr];
                    rptr <= rptr + 1;
                    count <= count - 1;
                    FULL <= 1'b0;
                    EMPTY <= (count == 3'd1);
                end
                default: ;    // No operation
            endcase
        end
    end

endmodule