module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // State variable to track the sequence

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
    end else begin
        case (state)
            0: begin // Initial state
                if (in) begin
                    state <= 1;
                end
            end
            1: begin // One '1' detected
                if (in) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin // Two '1's detected
                if (in) begin
                    state <= 3;
                end else begin
                    state <= 0;
                end
            end
            3: begin // Three '1's detected
                if (in) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
            end
            4: begin // Four '1's detected
                if (in) begin
                    state <= 5;
                end else begin
                    state <= 0;
                end
            end
            5: begin // Five '1's detected
                if (in) begin
                    state <= 6; // Potential flag or error
                end else begin
                    state <= 0; // Discard bit
                    disc <= 1;
                end
            end
            6: begin // Six '1's detected
                if (in) begin
                    state <= 7; // Error condition
                end else begin
                    state <= 0; // Flag condition
                    flag <= 1;
                end
            end
            7: begin // Seven or more '1's detected (error)
                if (in) begin
                    state <= 7; // Remain in error state
                end else begin
                    state <= 0; // Reset state after error
                    err <= 1;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign disc = (state == 5 && ~in);
assign flag = (state == 6 && ~in);
assign err = (state == 7 && ~in);

endmodule