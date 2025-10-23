module TopModule(
    input         clk,
    input         reset,
    output        shift_ena
);

reg [1:0] state; // 2-state FSM: IDLE and SHIFT_ENABLE
reg [1:0] counter; // 2-bit counter to count 4 clock cycles
reg         shift_ena_reg;

// State encoding
localparam IDLE = 2'b00;
localparam SHIFT_ENABLE = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        state <= SHIFT_ENABLE;
        counter <= 2'b00;
        shift_ena_reg <= 1'b1;
    end else begin
        case (state)
            IDLE: begin
                if (reset) begin
                    state <= SHIFT_ENABLE;
                    counter <= 2'b00;
                    shift_ena_reg <= 1'b1;
                end else begin
                    state <= IDLE;
                    shift_ena_reg <= 1'b0;
                end
            end
            SHIFT_ENABLE: begin
                if (counter == 2'b11) begin
                    state <= IDLE;
                    shift_ena_reg <= 1'b0;
                end else begin
                    state <= SHIFT_ENABLE;
                    counter <= counter + 1'b1;
                    shift_ena_reg <= 1'b1;
                end
            end
            default: begin
                state <= IDLE;
                shift_ena_reg <= 1'b0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule