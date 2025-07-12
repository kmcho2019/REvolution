module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to keep track of clock cycles
reg [1:0] state; // current state of the FSM
parameter IDLE = 2'b00, SHIFT_ENABLE = 2'b01;

always @(posedge clk) begin
    if (reset) begin // reset is active high synchronous
        state <= SHIFT_ENABLE;
        counter <= 2'b00; // reset counter
        shift_ena <= 1'b1;
    end else begin
        case (state)
            IDLE: begin
                shift_ena <= 1'b0;
                // stay in IDLE state
            end
            SHIFT_ENABLE: begin
                shift_ena <= 1'b1;
                if (counter == 2'b11) begin // 4 clock cycles have passed
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule