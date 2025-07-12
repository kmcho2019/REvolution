module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT
reg [1:0] counter; // counter for 4 clock cycles
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // SHIFT
        counter <= 0;
        shift_ena_reg <= 1;
    end else begin
        case (state)
            1: begin // SHIFT
                if (counter == 3) begin
                    state <= 0; // IDLE
                    counter <= 0;
                    shift_ena_reg <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            default: begin // IDLE
                state <= 0;
                counter <= 0;
                shift_ena_reg <= 0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule