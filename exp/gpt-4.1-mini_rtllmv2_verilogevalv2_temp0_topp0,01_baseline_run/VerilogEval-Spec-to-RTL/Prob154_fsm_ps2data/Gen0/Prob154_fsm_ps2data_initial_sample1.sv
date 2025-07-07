module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE1;
                    end else begin
                        state <= IDLE;
                    end
                end

                BYTE1: begin
                    byte2 <= in;
                    state <= BYTE2;
                end

                BYTE2: begin
                    byte3 <= in;
                    // Output the 3-byte message and assert done next cycle
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule