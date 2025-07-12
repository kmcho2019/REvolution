module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: SHIFT_COUNT_1, 3: SHIFT_COUNT_2
reg [1:0] count; // counter for shift_ena assertion

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // transition to SHIFT state when reset is asserted
        count <= 0;
        shift_ena <= 1; // assert shift_ena immediately
    end else begin
        case (state)
            1: begin // SHIFT state
                if (count < 3) begin // count 4 cycles (0, 1, 2, 3)
                    count <= count + 1;
                end else begin
                    state <= 0; // transition to IDLE state after 4 cycles
                    shift_ena <= 0;
                end
            end
            0: begin // IDLE state
                shift_ena <= 0;
            end
        endcase
    end
end

endmodule