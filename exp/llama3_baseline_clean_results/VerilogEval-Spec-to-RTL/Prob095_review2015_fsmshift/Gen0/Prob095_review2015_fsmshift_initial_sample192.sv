module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT_ENA, 2: COUNTING
reg [1:0] counter; // counter to keep track of clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // go to SHIFT_ENA state on reset
        counter <= 0; // reset counter
        shift_ena <= 1; // assert shift_ena on reset
    end else begin
        case (state)
            1: begin // SHIFT_ENA state
                if (counter == 3) begin // if counter is 3, it means 4 cycles have passed
                    state <= 2; // go to COUNTING state to deassert shift_ena
                    shift_ena <= 0; // deassert shift_ena after 4 cycles
                end else begin
                    counter <= counter + 1; // increment counter
                end
            end
            2: begin // COUNTING state
                state <= 0; // go to IDLE state
            end
            default: ; // do nothing in IDLE state
        endcase
    end
end

endmodule