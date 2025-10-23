module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2-3: not used
reg [1:0] counter;
reg shift_ena_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 1; // SHIFT
        counter <= 0;
        shift_ena_reg <= 1'b1;
    end else begin
        case(state)
            1: begin // SHIFT
                if(counter == 4'd3) begin
                    state <= 0; // IDLE
                    counter <= 0;
                    shift_ena_reg <= 1'b0;
                end else begin
                    counter <= counter + 1;
                    shift_ena_reg <= 1'b1;
                end
            end
            0: begin // IDLE
                shift_ena_reg <= 1'b0;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule