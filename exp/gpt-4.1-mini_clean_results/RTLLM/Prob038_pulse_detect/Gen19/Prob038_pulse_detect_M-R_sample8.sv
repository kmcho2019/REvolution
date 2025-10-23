module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum reg [1:0] {
        IDLE = 2'd0,
        HIGH = 2'd1,
        LOW  = 2'd2
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            // Default output deassertion
            data_out <= 1'b0;

            case(state)
                IDLE: begin
                    if (data_in)
                        state <= HIGH;
                    else
                        state <= IDLE;
                end
                HIGH: begin
                    if (~data_in) begin
                        state <= LOW;
                        // Pulse detected at falling edge: assert data_out
                        data_out <= 1'b1;
                    end else
                        state <= HIGH;
                end
                LOW: begin
                    if (data_in)
                        state <= HIGH;
                    else
                        state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule