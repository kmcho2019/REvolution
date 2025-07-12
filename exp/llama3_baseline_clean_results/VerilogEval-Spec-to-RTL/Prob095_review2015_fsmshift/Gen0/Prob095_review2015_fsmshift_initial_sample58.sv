module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state;
reg [1:0] counter;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // SHIFT_ENABLE
        counter <= 2'b00;
        shift_ena_reg <= 1'b1;
    end else begin
        case (state)
            2'b01: begin // SHIFT_ENABLE
                if (counter == 2'b11) begin
                    state <= 2'b00; // IDLE
                    shift_ena_reg <= 1'b0;
                end else begin
                    counter <= counter + 1;
                end
            end
            2'b00: begin // IDLE
                shift_ena_reg <= 1'b0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule