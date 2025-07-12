module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state;
    reg [23:0] byte_buffer;
    reg buffer_valid;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx;
            byte_buffer <= 24'b0;
            buffer_valid <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            buffer_valid <= 1'b0;

            // State transitions
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        state <= BYTE1;
                        byte_buffer[23:16] <= in;
                    end
                end
                
                BYTE1: begin
                    state <= BYTE2;
                    byte_buffer[15:8] <= in;
                end
                
                BYTE2: begin
                    state <= IDLE;
                    byte_buffer[7:0] <= in;
                    buffer_valid <= 1'b1;
                end
                
                default: state <= IDLE;
            endcase

            // Output update only when valid
            if (buffer_valid) begin
                out_bytes <= byte_buffer;
                done <= 1'b1;
            end else if (state == IDLE) begin
                out_bytes <= 24'bx; // Don't-care when idle
            end
        end
    end

endmodule