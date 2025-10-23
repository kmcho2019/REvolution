module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state; // 2-state FSM: IDLE (2'b00) and SHIFT (2'b01)
    logic [1:0] counter; // counter to keep track of the number of clock cycles

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'b01; // transition to SHIFT state when reset is asserted
            counter <= 2'b11; // initialize counter to 3 (4 clock cycles - 1)
            shift_ena <= 1'b1;
        end else begin
            case (state)
                2'b00: begin // IDLE state
                    state <= 2'b00;
                    counter <= 2'b00;
                    shift_ena <= 1'b0;
                end
                2'b01: begin // SHIFT state
                    if (counter > 0) begin
                        state <= 2'b01;
                        counter <= counter - 1'b1;
                        shift_ena <= 1'b1;
                    end else begin
                        state <= 2'b00;
                        counter <= 2'b00;
                        shift_ena <= 1'b0;
                    end
                end
                default: begin
                    state <= 2'b00;
                    counter <= 2'b00;
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule