module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT_ENABLE, 2: COUNTING
reg [1:0] counter;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // SHIFT_ENABLE
        counter <= 0;
        shift_ena_reg <= 1;
    end else begin
        case (state)
            1: begin // SHIFT_ENABLE
                if (counter == 3) begin
                    state <= 0; // IDLE
                    shift_ena_reg <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            0: begin // IDLE
                // do nothing
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule