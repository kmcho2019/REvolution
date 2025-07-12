module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [2:0] state;
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data == 1) begin
                    state <= 1; // Move to ONE state
                end
            end
            1: begin // ONE state
                if (data == 1) begin
                    state <= 3; // Move to ONE_ONE state
                end else if (data == 0) begin
                    state <= 2; // Move to ONE_ZERO state
                end
            end
            2: begin // ONE_ZERO state
                if (data == 1) begin
                    state <= 3; // Move to ONE_ONE state
                end else if (data == 0) begin
                    state <= 0; // Move back to IDLE state
                end
            end
            3: begin // ONE_ONE state
                if (data == 0) begin
                    state <= 4; // Move to ONE_ONE_ZERO state
                end else begin
                    state <= 1; // Move back to ONE state
                end
            end
            4: begin // ONE_ONE_ZERO state
                if (data == 1) begin
                    state <= 5; // Move to final state
                end else begin
                    state <= 0; // Move back to IDLE state
                end
            end
            default: begin // Final state
                start_shifting_reg <= 1;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 0;
    end else if (state == 5) begin
        start_shifting <= 1;
    end else begin
        start_shifting <= start_shifting_reg;
    end
end

endmodule