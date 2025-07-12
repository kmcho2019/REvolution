module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    // FSM states
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state;
    reg [1:0] counter;  // 2-bit counter counts 3 down to 0 (4 cycles)

    always @(posedge clk) begin
        if (reset) begin
            state   <= ENABLE;
            counter <= 2'd3;     // 4 cycles: 3,2,1,0
        end else begin
            case(state)
                ENABLE: begin
                    if (counter != 0)
                        counter <= counter - 1;
                    else
                        state <= IDLE;  // after counting down to 0, go idle
                end
                IDLE: begin
                    counter <= 0;  // ensure counter stays zero in IDLE
                end
            endcase
        end
    end

    // shift_ena is asserted for all 4 cycles while counting down in ENABLE
    // i.e., when state==ENABLE, shift_ena=1 even when counter=0 (last cycle)
    assign shift_ena = (state == ENABLE);

endmodule