module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary encoded states
    reg [1:0] state;
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    // Shift register for byte collection
    reg [23:0] byte_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_shift <= 24'bx;
            out_bytes <= 24'bx;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default assignment
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_shift <= {in, 16'b0};  // Store first byte
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    byte_shift <= {byte_shift[23:16], in, 8'b0};  // Shift in second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    out_bytes <= {byte_shift[23:8], in};  // Final byte and output
                    done <= 1'b1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule