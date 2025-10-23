module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: IDLE (0) and SHIFT_ENA (1,2,3)
reg [1:0] count; // counter to count 4 clock cycles
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Reset state
        count <= 0;
        shift_ena_reg <= 1;
    end else begin
        case (state)
            1: begin
                if (count == 4'd3) begin
                    state <= 0; // Move to IDLE state after 4 clock cycles
                    shift_ena_reg <= 0;
                end else begin
                    state <= state + 1;
                    count <= count + 1;
                    shift_ena_reg <= 1;
                end
            end
            0: begin // IDLE state
                state <= 0;
                shift_ena_reg <= 0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule