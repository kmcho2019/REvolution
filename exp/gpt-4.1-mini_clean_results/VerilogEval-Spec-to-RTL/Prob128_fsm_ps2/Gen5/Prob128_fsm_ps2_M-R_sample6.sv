module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE   = 2'd0,
        BYTE1  = 2'd1,
        BYTE2  = 2'd2
    } state_t;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            case(state)
                IDLE: begin
                    if (in[3])
                        state <= BYTE1;
                    else
                        state <= IDLE;
                end
                BYTE1: begin
                    state <= BYTE2;
                end
                BYTE2: begin
                    state <= IDLE;
                    done <= 1'b1;  // Done after receiving third byte
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule