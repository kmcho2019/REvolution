module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        state <= BYTE2;
                    end
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