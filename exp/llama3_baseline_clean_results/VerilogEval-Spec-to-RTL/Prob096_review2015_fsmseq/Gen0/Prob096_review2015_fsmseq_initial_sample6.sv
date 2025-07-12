module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [1:0] state; // State variable
reg start_shifting_reg; // Registered output

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to S_IDLE
        start_shifting_reg <= 1'b0; // Reset output
    end else begin
        case (state)
            2'b00: begin // S_IDLE
                if (data) begin
                    state <= 2'b01; // Move to S_GOT_1
                end else begin
                    state <= 2'b00; // Stay in S_IDLE
                end
            end
            2'b01: begin // S_GOT_1
                if (data) begin
                    state <= 2'b10; // Move to S_GOT_11
                end else begin
                    state <= 2'b00; // Reset to S_IDLE
                end
            end
            2'b10: begin // S_GOT_11
                if (data) begin
                    state <= 2'b00; // Reset to S_IDLE if data is '1'
                end else begin
                    state <= 2'b11; // Move to S_GOT_110
                end
            end
            2'b11: begin // S_GOT_110
                if (data) begin
                    state <= 2'b11; // Stay in S_GOT_110 and set output
                    start_shifting_reg <= 1'b1;
                end else begin
                    state <= 2'b00; // Reset to S_IDLE
                end
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule