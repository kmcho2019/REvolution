module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Optimized state encoding
    parameter S0 = 3'b000;  // Initial/zero state
    parameter S1 = 3'b001;  // 1 '1'
    parameter S2 = 3'b010;  // 2 '1's
    parameter S3 = 3'b011;  // 3 '1's
    parameter S4 = 3'b100;  // 4 '1's
    parameter S5 = 3'b101;  // 5 '1's (discard point)
    parameter S6 = 3'b110;  // 6 '1's (flag point)
    parameter S7 = 3'b111;  // 7+ '1's (error)

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            {disc, flag, err} <= 3'b0;
        end else begin
            // Default outputs (only set when conditions met)
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions
            case (state)
                S0: state <= in ? S1 : S0;
                S1: state <= in ? S2 : S0;
                S2: state <= in ? S3 : S0;
                S3: state <= in ? S4 : S0;
                S4: state <= in ? S5 : S0;
                S5: begin
                    if (in) state <= S6;
                    else disc <= 1;
                end
                S6: begin
                    if (in) state <= S7;
                    else flag <= 1;
                end
                S7: begin
                    if (in) err <= 1;
                    else state <= S0;
                end
            endcase

            // Handle error state persistence
            if (state == S7 && in)
                err <= 1;
        end
    end

endmodule