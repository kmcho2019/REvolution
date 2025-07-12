module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 8 states: 3 bits (S0 to S7)

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to S0
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        case (state)
            0: begin // S0
                if (in) begin
                    state <= 1; // Transition to S1
                end else begin
                    state <= 0; // Stay in S0
                end
            end
            1: begin // S1
                if (in) begin
                    state <= 2; // Transition to S2
                end else begin
                    state <= 0; // Transition to S0
                end
            end
            2: begin // S2
                if (in) begin
                    state <= 3; // Transition to S3
                end else begin
                    state <= 0; // Transition to S0
                end
            end
            3: begin // S3
                if (in) begin
                    state <= 4; // Transition to S4
                end else begin
                    state <= 0; // Transition to S0
                end
            end
            4: begin // S4
                if (in) begin
                    state <= 5; // Transition to S5
                end else begin
                    state <= 0; // Transition to S0
                end
            end
            5: begin // S5
                if (in) begin
                    state <= 6; // Transition to S6
                    disc <= 1; // Set disc to 1
                end else begin
                    state <= 0; // Transition to S0
                end
            end
            6: begin // S6
                if (in) begin
                    state <= 7; // Transition to S7
                    err <= 1; // Set err to 1
                end else begin
                    state <= 0; // Transition to S0
                    flag <= 1; // Set flag to 1
                end
            end
            7: begin // S7
                if (in) begin
                    state <= 7; // Stay in S7
                end else begin
                    state <= 0; // Transition to S0
                end
            end
        endcase
        if (state != 5 && state != 6 && state != 7) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end
    end
end

endmodule