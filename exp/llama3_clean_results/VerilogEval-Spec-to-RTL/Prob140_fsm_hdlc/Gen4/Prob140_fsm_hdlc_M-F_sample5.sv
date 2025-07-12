module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

// Define states
parameter IDLE = 4'b0000,
          ONE = 4'b0001,
          TWO_ONES = 4'b0010,
          THREE_ONES = 4'b0011,
          FOUR_ONES = 4'b0100,
          FIVE_ONES = 4'b0101,
          SIX_ONES = 4'b0110,
          ERROR = 4'b0111;

reg [3:0] state;
reg [3:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                if (in) begin
                    state <= ONE;
                end else begin
                    state <= IDLE;
                end
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            ONE: begin
                if (in) begin
                    state <= TWO_ONES;
                end else begin
                    state <= IDLE;
                end
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            TWO_ONES: begin
                if (in) begin
                    state <= THREE_ONES;
                end else begin
                    state <= IDLE;
                end
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            THREE_ONES: begin
                if (in) begin
                    state <= FOUR_ONES;
                end else begin
                    state <= IDLE;
                end
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            FOUR_ONES: begin
                if (in) begin
                    state <= FIVE_ONES;
                end else begin
                    state <= IDLE;
                end
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            FIVE_ONES: begin
                if (in) begin
                    state <= SIX_ONES;
                end else begin
                    state <= IDLE;
                    disc <= 1'b1; // Assert disc when transitioning from 5 ones to 0
                end
                flag <= 1'b0;
                err <= 1'b0;
            end
            SIX_ONES: begin
                if (in) begin
                    state <= ERROR; // More than 6 ones is an error
                end else begin
                    state <= IDLE;
                    flag <= 1'b1; // Assert flag when transitioning from 6 ones to 0
                end
                disc <= 1'b0;
                err <= 1'b0;
            end
            ERROR: begin
                state <= ERROR; // Stay in error state until a 0 is received
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b1;
                if (!in) begin
                    state <= IDLE; // Reset error state when a 0 is received
                end
            end
            default: begin
                state <= IDLE;
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
        endcase
    end
end

endmodule