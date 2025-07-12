module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter; // Counter to keep track of the cycles
reg [1:0] state; // State of the FSM (2 states: idle and assert_ena)
parameter IDLE = 2'b00, ASSERT_ENA = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        state <= ASSERT_ENA;
        counter <= 0;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            ASSERT_ENA: begin
                if (counter == 4'd3) begin // After 4 cycles
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1;
                    shift_ena <= 1'b1;
                end
            end
            IDLE: begin
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule