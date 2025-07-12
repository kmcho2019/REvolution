module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0 - IDLE, 1 - SHIFT, 2 - COUNT_1, 3 - COUNT_2, others - unused
reg [1:0] counter; // counter to keep track of shift cycles
reg shift_ena_reg; // register for shift_ena

always @(posedge clk) begin
    if(reset) begin
        state <= 1; // go to SHIFT state on reset
        counter <= 0;
        shift_ena_reg <= 1'b1;
    end else begin
        case(state)
            1: begin // SHIFT state
                if(counter == 4'd3) begin // 4 cycles have passed
                    state <= 0; // go back to IDLE state
                    shift_ena_reg <= 1'b0;
                end else begin
                    counter <= counter + 1;
                end
            end
            default: begin // IDLE state
                state <= 0;
                counter <= 0;
                shift_ena_reg <= 1'b0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule