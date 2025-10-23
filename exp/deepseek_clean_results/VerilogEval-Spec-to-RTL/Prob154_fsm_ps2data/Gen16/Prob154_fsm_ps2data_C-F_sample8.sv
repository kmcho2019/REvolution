module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary state encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE1 = 2'b01;
    localparam [1:0] BYTE2 = 2'b10;

    reg [1:0] state;
    reg [23:0] byte_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx;
            byte_shift <= 24'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_shift <= {in, 16'b0}; // Store first byte
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    byte_shift <= {byte_shift[23:16], in, 8'b0}; // Shift in second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    out_bytes <= {byte_shift[23:8], in}; // Complete the 3-byte message
                    done <= 1'b1;                       // Assert done
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule