module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: count_1, 3: count_2
reg [1:0] count;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // shifting state
        count <= 0;
        shift_ena_reg <= 1'b1;
    end else begin
        case (state)
            1: begin
                if (count == 4'd3) begin
                    state <= 0; // idle state
                    shift_ena_reg <= 1'b0;
                end else begin
                    count <= count + 1;
                end
            end
            0: begin
                // do nothing
            end
            default: begin
                state <= 0; // idle state
                shift_ena_reg <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk) begin
    shift_ena <= shift_ena_reg;
end

endmodule