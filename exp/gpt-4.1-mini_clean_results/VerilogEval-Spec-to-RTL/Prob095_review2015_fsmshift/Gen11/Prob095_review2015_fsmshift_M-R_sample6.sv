module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    typedef enum reg {IDLE, ENABLE} state_t;
    reg [2:0] count;
    reg state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state     <= ENABLE;
            count     <= 3'd4;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                ENABLE: begin
                    if (count > 1) begin
                        count     <= count - 1;
                        shift_ena <= 1'b1;
                    end else begin
                        // count == 1: next cycle move to IDLE and disable shift_ena
                        state     <= IDLE;
                        shift_ena <= 1'b0;
                    end
                end
                IDLE: begin
                    shift_ena <= 1'b0;
                end
                default: begin
                    state     <= IDLE;
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule