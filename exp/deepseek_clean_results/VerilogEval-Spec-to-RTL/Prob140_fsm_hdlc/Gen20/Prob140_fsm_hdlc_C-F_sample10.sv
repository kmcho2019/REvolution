module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State definitions with counter values
    localparam [2:0] 
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            {disc, flag, err} <= 3'b000;
        end else begin
            // Default outputs (only set when conditions met)
            {disc, flag, err} <= 3'b000;

            // State transition and output logic
            if (in) begin
                if (state < S7) state <= state + 1;
                if (state >= S6) err <= 1'b1;
            end else begin
                case (state)
                    S5: disc <= 1'b1;
                    S6: flag <= 1'b1;
                    default: ; // No action for other states
                endcase
                state <= S0;
            end
        end
    end

endmodule