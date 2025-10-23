module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shifting (counter), 3: shifting (counter)
reg [1:0] counter; // counter to keep track of the number of clock cycles in shifting state
reg shift_ena_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 1; // reset to shifting state
        counter <= 0; // reset counter
        shift_ena_reg <= 1; // assert shift_ena
    end else begin
        case(state)
            1: begin
                counter <= counter + 1;
                if(counter == 3) begin
                    state <= 0; // go back to idle state after 4 cycles
                    shift_ena_reg <= 0; // deassert shift_ena
                end else begin
                    state <= 1; // stay in shifting state
                    shift_ena_reg <= 1; // keep shift_ena asserted
                end
            end
            0: begin
                state <= 0; // stay in idle state
                shift_ena_reg <= 0; // keep shift_ena deasserted
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule