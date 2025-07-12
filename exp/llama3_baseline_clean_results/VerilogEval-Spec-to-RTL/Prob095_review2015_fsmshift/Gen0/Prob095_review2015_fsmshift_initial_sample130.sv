module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: reset, 2: shift
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // go to reset state
        counter <= 0;
    end else if (state == 1) begin // reset state
        if (counter < 4) begin
            state <= 1; // stay in reset state
            counter <= counter + 1;
        end else begin
            state <= 0; // go to idle state
            counter <= 0;
        end
    end else if (state == 0) begin // idle state
        // stay in idle state
    end
end

always @(*) begin
    case(state)
        1: shift_ena = 1;
        0: shift_ena = 0;
        default: shift_ena = 0;
    endcase
end

endmodule