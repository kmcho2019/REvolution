module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [2:0] state; // State machine states
parameter IDLE = 3'b000, // Initial state
           ONE = 3'b001, // Seen one '1'
           TWO_ONES = 3'b010, // Seen two '1's
           THREE_ONES = 3'b011, // Seen three '1's
           FOUR_ONES = 3'b100, // Seen four '1's
           FIVE_ONES = 3'b101, // Seen five '1's
           FLAG = 3'b110, // Flag detected
           ERROR = 3'b111; // Error detected

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
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
                    state <= ERROR;
                end else begin
                    state <= IDLE;
                end
            end
            FLAG: begin
                state <= IDLE;
            end
            ERROR: begin
                if (~in) begin
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

assign disc = (state == FIVE_ONES) & (~in);
assign flag = (state == FIVE_ONES) & in & (~in);
assign err = (state == ERROR);

endmodule