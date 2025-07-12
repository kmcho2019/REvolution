module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state;
reg start_shifting_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        start_shifting_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle
                if (data) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // State1
                if (data) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b10: begin // State2
                if (~data) begin
                    state <= 2'b11;
                end else begin
                    state <= 2'b01;
                end
            end
            2'b11: begin // State3 and State4
                if (data) begin
                    start_shifting_reg <= 1'b1;
                    state <= 2'b11;
                end else begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule