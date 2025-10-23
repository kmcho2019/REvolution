module TopModule (
    input        clk,
    input        reset,
    output       shift_ena
);

reg [1:0] state; // 0: initial, 1: shifting, 2: idle, 3: reset
reg [1:0] count;
reg        shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b10; // reset state
        count <= 2'b00;
        shift_ena_reg <= 1'b1;
    end else begin
        case (state)
            2'b10: begin // reset state
                if (count == 4'b1000) begin
                    state <= 2'b00; // initial state
                    count <= 2'b00;
                    shift_ena_reg <= 1'b0;
                end else begin
                    count <= count + 1'b1;
                end
            end
            2'b00: begin // initial state
                // This state will not be used in this implementation,
                // but it's included here for completeness.
                // To detect a proper bit pattern, you would need additional
                // inputs and logic to transition to a shifting state.
                state <= 2'b00;
                count <= 2'b00;
                shift_ena_reg <= 1'b0;
            end
            2'b01: begin // shifting state
                // This state will not be used in this implementation,
                // but it's included here for completeness.
                // To implement shifting, you would need additional
                // inputs and logic to transition back to the initial state.
                state <= 2'b01;
                count <= 2'b00;
                shift_ena_reg <= 1'b0;
            end
            default: begin
                state <= 2'b00; // default state
                count <= 2'b00;
                shift_ena_reg <= 1'b0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule