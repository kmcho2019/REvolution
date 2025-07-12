module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT_COUNTING, 2: SHIFT_DONE
reg [1:0] counter; // counter to keep track of shift_ena high cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // go to SHIFT_COUNTING state when reset is high
        counter <= 0;
        shift_ena <= 1;
    end else begin
        case (state)
            1: begin // SHIFT_COUNTING state
                if (counter == 3) begin
                    state <= 2; // go to SHIFT_DONE state after 4 cycles
                    shift_ena <= 0;
                end else begin
                    counter <= counter + 1;
                    shift_ena <= 1;
                end
            end
            2: begin // SHIFT_DONE state
                shift_ena <= 0;
            end
            default: ; // IDLE state, do nothing
        endcase
    end
end

endmodule