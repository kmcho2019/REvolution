module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    // State encoding
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        ACTIVE = 1'b1
    } state_t;

    state_t state;
    reg [1:0] cycle_cnt; // 2-bit counter counts from 0 to 3

    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            cycle_cnt <= 2'd0;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                ACTIVE: begin
                    if (cycle_cnt == 2'd3) begin
                        state <= IDLE;
                        shift_ena <= 1'b0;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                        shift_ena <= 1'b1;
                    end
                end
                IDLE: begin
                    shift_ena <= 1'b0;
                    // Remain in IDLE until next reset
                end
            endcase
        end
    end

endmodule