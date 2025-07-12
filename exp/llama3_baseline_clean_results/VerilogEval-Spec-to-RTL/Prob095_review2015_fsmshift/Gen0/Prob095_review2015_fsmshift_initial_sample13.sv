module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

    reg [1:0] state; // 0: IDLE, 1: SHIFT_ENABLE, 2: COUNTING
    reg [1:0] counter; // counter to keep track of clock cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 1; // enter SHIFT_ENABLE state when reset
            counter <= 0;
            shift_ena <= 1;
        end else begin
            case (state)
                1: begin // SHIFT_ENABLE state
                    if (counter == 3) begin
                        state <= 0; // transition to IDLE state after 4 cycles
                        counter <= 0;
                        shift_ena <= 0;
                    end else begin
                        counter <= counter + 1;
                        shift_ena <= 1;
                    end
                end
                0: begin // IDLE state
                    shift_ena <= 0;
                end
            endcase
        end
    end

endmodule