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
           SIX_ONES = 4'b0110, // Seen six '1's
           FLAG = 4'b0111, // Flag detected
           ERROR = 4'b1000; // Error detected

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONE;
                end else begin
                    state <= IDLE;
                end
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            ONE: begin
                if (in) begin
                    state <= TWO_ONES;
                end else begin
                    state <= IDLE;
                end
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            TWO_ONES: begin
                if (in) begin
                    state <= THREE_ONES;
                end else begin
                    state <= IDLE;
                end
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            THREE_ONES: begin
                if (in) begin
                    state <= FOUR_ONES;
                end else begin
                    state <= IDLE;
                end
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            FOUR_ONES: begin
                if (in) begin
                    state <= FIVE_ONES;
                end else begin
                    state <= IDLE;
                end
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            FIVE_ONES: begin
                if (in) begin
                    state <= SIX_ONES;
                end else begin
                    state <= IDLE;
                    disc <= 1; // Discard bit
                end
                flag <= 0;
                err <= 0;
            end
            SIX_ONES: begin
                if (in) begin
                    state <= ERROR;
                end else begin
                    state <= FLAG;
                end
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            FLAG: begin
                state <= IDLE;
                disc <= 0;
                flag <= 1; // Flag detected
                err <= 0;
            end
            ERROR: begin
                if (~in) begin
                    state <= IDLE;
                end
                disc <= 0;
                flag <= 0;
                err <= 1; // Error detected
            end
            default: begin
                state <= IDLE;
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
        endcase
    end
end

endmodule