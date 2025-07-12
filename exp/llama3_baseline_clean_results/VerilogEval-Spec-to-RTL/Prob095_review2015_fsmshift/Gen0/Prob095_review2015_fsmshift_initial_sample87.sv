module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: enabling, 2: enabled, 3: disabled
reg [1:0] counter;
reg shift_ena_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 1; // enabling state
        counter <= 0;
        shift_ena_reg <= 1'b1;
    end else begin
        case(state)
            1: begin // enabling state
                if(counter == 3) begin
                    state <= 3; // disabled state
                    counter <= 0;
                    shift_ena_reg <= 1'b0;
                end else begin
                    counter <= counter + 1;
                end
            end
            3: begin // disabled state
                // stay in this state until reset
            end
            default: begin
                // default state
                state <= 3; // disabled state
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule