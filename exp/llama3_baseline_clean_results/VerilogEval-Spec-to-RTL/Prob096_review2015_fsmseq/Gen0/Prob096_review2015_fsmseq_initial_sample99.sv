module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [2:0] state; // 3 bits to represent 5 states (S0 to S4)
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state to S0
        start_shifting_reg <= 0; // Reset start_shifting to 0
    end else begin
        case (state)
            0: begin // S0
                if (data) state <= 1; // If '1', move to S1
            end
            1: begin // S1
                if (data) state <= 2; // If '1', move to S2
                else state <= 0; // If '0', reset to S0
            end
            2: begin // S2
                if (~data) state <= 3; // If '0', move to S3
                else state <= 1; // If '1', reset to S1
            end
            3: begin // S3
                if (data) state <= 4; // If '1', move to S4
                else state <= 0; // If '0', reset to S0
            end
            4: begin // S4
                start_shifting_reg <= 1; // Set start_shifting to 1
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule