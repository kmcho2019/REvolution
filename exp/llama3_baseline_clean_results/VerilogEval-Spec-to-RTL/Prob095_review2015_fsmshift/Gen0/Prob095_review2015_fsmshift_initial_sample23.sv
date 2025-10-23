module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT_ENABLE, 2: COUNTING
reg [1:0] counter; // counter to keep track of shift_ena high cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // SHIFT_ENABLE
        counter <= 0;
        shift_ena <= 1;
    end else begin
        case (state)
            1: begin // SHIFT_ENABLE
                counter <= counter + 1;
                if (counter == 3) begin
                    state <= 0; // IDLE
                end
                shift_ena <= 1;
            end
            0: begin // IDLE
                shift_ena <= 0;
            end
        endcase
    end
end

endmodule