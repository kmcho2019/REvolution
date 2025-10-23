module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam HIGH = 1'b1;

    reg state;
    reg data_in_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            data_in_d <= 1'b0;
            data_out  <= 1'b0;
        end else begin
            // Sample data_in_d only when state is HIGH or on rising edge condition
            // to reduce toggling
            if ((state == IDLE && data_in == 1'b1) || (state == HIGH)) begin
                data_in_d <= data_in;
            end
            // State update
            case (state)
                IDLE: begin
                    if (data_in == 1'b1)
                        state <= HIGH;
                    else
                        state <= IDLE;
                end
                HIGH: begin
                    if (data_in == 1'b0)
                        state <= IDLE;
                    else
                        state <= HIGH;
                end
                default: state <= IDLE;
            endcase

            // Output pulse detection: assert data_out for 1 cycle when falling edge of data_in after HIGH state
            if ((state == HIGH) && (data_in == 1'b0) && (data_in_d == 1'b1))
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule