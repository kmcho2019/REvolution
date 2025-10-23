module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [3:0] state; // State machine states
parameter IDLE = 4'b0000, // Initial state
           ONE = 4'b0001, // Seen one '1'
           TWO_ONES = 4'b0010, // Seen two '1's
           THREE_ONES = 4'b0011, // Seen three '1's
           FOUR_ONES = 4'b0100, // Seen four '1's
           FIVE_ONES = 4'b0101, // Seen five '1's
           SIX_ONES = 4'b0110, // Seen six '1's (potential flag)
           SEVEN_ONES = 4'b0111; // Seen seven '1's (error)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONE;
                end else begin
                    state <= IDLE;
                end
            end
            ONE: begin
                if (in) begin
                    state <= TWO_ONES;
                end else begin
                    state <= IDLE;
                end
            end
            TWO_ONES: begin
                if (in) begin
                    state <= THREE_ONES;
                end else begin
                    state <= IDLE;
                end
            end
            THREE_ONES: begin
                if (in) begin
                    state <= FOUR_ONES;
                end else begin
                    state <= IDLE;
                end
            end
            FOUR_ONES: begin
                if (in) begin
                    state <= FIVE_ONES;
                end else begin
                    state <= IDLE;
                end
            end
            FIVE_ONES: begin
                if (in) begin
                    state <= SIX_ONES;
                end else begin
                    state <= IDLE;
                    disc <= 1'b1; // Discard bit
                end
            end
            SIX_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                end else begin
                    state <= IDLE;
                    flag <= 1'b1; // Flag detected
                end
            end
            SEVEN_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                end else begin
                    state <= IDLE;
                end
                err <= 1'b1; // Error detected
            end
            default: begin
                state <= IDLE;
            end
        endcase

        // Reset output signals
        if (state!= SIX_ONES) flag <= 1'b0;
        if (state!= FIVE_ONES && state!= IDLE) disc <= 1'b0;
        if (state!= SEVEN_ONES) err <= 1'b0;
    end
end

endmodule