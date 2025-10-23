module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    typedef enum logic [1:0] {IDLE=2'd0, BYTE2=2'd1, BYTE3=2'd2} state_t;
    state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            case (state)
                IDLE: begin
                    if (in[3]) 
                        state <= BYTE2;
                end
                BYTE2: begin
                    state <= BYTE3;
                end
                BYTE3: begin
                    done <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule