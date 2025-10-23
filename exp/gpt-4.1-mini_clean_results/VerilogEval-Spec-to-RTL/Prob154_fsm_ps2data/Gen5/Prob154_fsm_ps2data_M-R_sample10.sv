module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot states for clarity
    localparam IDLE  = 3'b001,
               CAP1  = 3'b010,
               CAP2  = 3'b100;

    reg [2:0] state, next_state;
    reg [1:0] byte_count;  // Counts bytes captured after detecting start byte (1 to 3)
    reg [23:0] message_reg;

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:    next_state = (in[3]) ? CAP1 : IDLE;
            CAP1:    next_state = CAP2;
            CAP2:    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            message_reg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
            byte_count <= 2'd0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case(state)
                IDLE: begin
                    byte_count <= 2'd0;
                    if (in[3]) begin
                        // Start byte detected: store it as the MSB byte
                        message_reg <= {in, 16'd0};
                        byte_count <= 2'd1;
                    end
                end
                CAP1: begin
                    // Shift next byte into lower 16 bits (second byte)
                    message_reg <= {message_reg[15:0], in};
                    byte_count <= 2'd2;
                end
                CAP2: begin
                    // Shift last byte and assert done with full message
                    message_reg <= {message_reg[15:0], in};
                    out_bytes <= {message_reg[15:0], in};
                    done <= 1'b1;
                    byte_count <= 2'd3;
                end
            endcase
        end
    end

endmodule