module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    // State encoding
    typedef enum reg [1:0] {
        WAIT_FOR_START = 2'd0,
        BYTE2          = 2'd1,
        BYTE3          = 2'd2
    } state_t;

    state_t state;
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_FOR_START;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case (state)
                WAIT_FOR_START: begin
                    // Wait for a byte with in[3] = 1
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE2;
                    end
                end

                BYTE2: begin
                    byte2 <= in;
                    state <= BYTE3;
                end

                BYTE3: begin
                    byte3 <= in;
                    // Assemble output and assert done in same cycle
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    state <= WAIT_FOR_START;
                end

                default: state <= WAIT_FOR_START;
            endcase
        end
    end

endmodule