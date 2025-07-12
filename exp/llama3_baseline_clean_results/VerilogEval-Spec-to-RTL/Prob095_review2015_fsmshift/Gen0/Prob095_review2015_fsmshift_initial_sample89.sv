module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: IDLE, 1: COUNTING
reg [1:0] count;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // go to COUNTING state
        count <= 0;
        shift_ena_reg <= 1'b1;
    end else if (state == 1) begin // in COUNTING state
        if (count == 4'd3) begin
            state <= 0; // go back to IDLE state
            shift_ena_reg <= 1'b0;
        end else begin
            count <= count + 1;
            shift_ena_reg <= 1'b1;
        end
    end else begin // in IDLE state
        count <= 0;
        shift_ena_reg <= 1'b0;
    end
end

assign shift_ena = shift_ena_reg;

endmodule