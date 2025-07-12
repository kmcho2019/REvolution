module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam ENABLE = 1'b1;

    reg state;
    reg [2:0] counter;  // 3-bit counter for 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            state   <= ENABLE;
            counter <= 3'd4;     // start counting down from 4
        end else begin
            case(state)
                ENABLE: begin
                    if (counter != 0)
                        counter <= counter - 1;
                    if (counter == 1)
                        state <= IDLE;  // after last enable cycle, go idle
                end
                IDLE: begin
                    // stay idle indefinitely until reset
                    counter <= 0;
                end
            endcase
        end
    end

    // shift_ena is high while counting down in ENABLE state
    assign shift_ena = (state == ENABLE) && (counter != 0);

endmodule