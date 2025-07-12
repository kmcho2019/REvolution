module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001,
               BYTE1 = 3'b010,
               BYTE2 = 3'b100;

    reg [2:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE:  next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and output updates
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
            done      <= 1'b0;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // default no done pulse

            case (next_state)
                BYTE1: begin
                    byte1 <= in;
                end
                BYTE2: begin
                    byte2 <= in;
                end
                IDLE: begin
                    if (state == BYTE2) begin
                        // We just finished receiving the 3rd byte
                        byte3     <= in;
                        out_bytes <= {byte1, byte2, in};
                        done      <= 1'b1;
                    end
                end
                default: ;
            endcase
        end
    end

endmodule