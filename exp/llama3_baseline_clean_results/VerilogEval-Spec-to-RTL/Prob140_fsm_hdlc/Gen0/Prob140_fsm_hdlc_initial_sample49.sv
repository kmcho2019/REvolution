module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states (S0 to S7)
reg disc_reg;
reg flag_reg;
reg err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to S0
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // S0
                if (in) begin
                    state <= 3'b001; // Move to S1
                end else begin
                    state <= 3'b000; // Stay in S0
                end
            end
            3'b001: begin // S1
                if (in) begin
                    state <= 3'b010; // Move to S2
                end else begin
                    state <= 3'b000; // Move back to S0
                end
            end
            3'b010: begin // S2
                if (in) begin
                    state <= 3'b011; // Move to S3
                end else begin
                    state <= 3'b000; // Move back to S0
                end
            end
            3'b011: begin // S3
                if (in) begin
                    state <= 3'b100; // Move to S4
                end else begin
                    state <= 3'b000; // Move back to S0
                end
            end
            3'b100: begin // S4
                if (in) begin
                    state <= 3'b101; // Move to S5
                end else begin
                    state <= 3'b000; // Move back to S0
                end
            end
            3'b101: begin // S5
                if (in) begin
                    state <= 3'b110; // Move to S6
                end else begin
                    state <= 3'b000; // Move back to S0
                end
            end
            3'b110: begin // S6
                if (in) begin
                    state <= 3'b111; // Move to S7
                    flag_reg <= 1'b1; // Assert flag
                end else begin
                    state <= 3'b000; // Move back to S0
                    disc_reg <= 1'b1; // Assert disc
                end
            end
            3'b111: begin // S7
                if (in) begin
                    state <= 3'b111; // Stay in S7
                end else begin
                    state <= 3'b000; // Move back to S0
                end
                err_reg <= 1'b1; // Assert err
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

// Reset outputs at the next clock cycle
always @(posedge clk) begin
    disc_reg <= 1'b0;
    flag_reg <= 1'b0;
    err_reg <= 1'b0;
end

endmodule