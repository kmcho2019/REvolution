module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Enum to represent states
    localparam IDLE = 4'b0000;
    localparam FOUND1 = 4'b0001;
    localparam FOUND11 = 4'b0010;
    localparam FOUND110 = 4'b0011;
    localparam FOUND1101 = 4'b0100;

    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to idle state when reset is high
            state <= IDLE;
            start_shifting <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data) begin
                        // If '1' is received, transition to FOUND1 state
                        state <= FOUND1;
                    end else begin
                        // If '0' is received, stay in IDLE state
                        state <= IDLE;
                    end
                end
                FOUND1: begin
                    if (data) begin
                        // If '1' is received, transition to FOUND11 state
                        state <= FOUND11;
                    end else begin
                        // If '0' is received, transition back to IDLE state
                        state <= IDLE;
                    end
                end
                FOUND11: begin
                    if (~data) begin
                        // If '0' is received, transition to FOUND110 state
                        state <= FOUND110;
                    end else begin
                        // If '1' is received, transition back to FOUND1 state
                        state <= FOUND1;
                    end
                end
                FOUND110: begin
                    if (data) begin
                        // If '1' is received, transition to FOUND1101 state
                        state <= FOUND1101;
                    end else begin
                        // If '0' is received, transition back to IDLE state
                        state <= IDLE;
                    end
                end
                FOUND1101: begin
                    // Stay in FOUND1101 state
                    state <= FOUND1101;
                end
                default: begin
                    // Default to IDLE state if state is unknown
                    state <= IDLE;
                end
            endcase

            // Set start_shifting based on state
            if (state == FOUND1101) begin
                start_shifting <= 1;
            end else begin
                start_shifting <= 0;
            end
        end
    end

endmodule