module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2-3: counting
reg [1:0] count;
reg shift_ena_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 1; // shifting
        count <= 0;
        shift_ena_reg <= 1;
    end else begin
        case (state)
            1: begin // shifting
                shift_ena_reg <= 1;
                state <= 2;
                count <= 1;
            end
            2: begin // counting
                shift_ena_reg <= 1;
                count <= count + 1;
                if (count == 3) begin
                    state <= 0; // idle
                end else begin
                    state <= 2;
                end
            end
            0: begin // idle
                shift_ena_reg <= 0;
            end
            default: begin
                state <= 0; // idle
                shift_ena_reg <= 0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule