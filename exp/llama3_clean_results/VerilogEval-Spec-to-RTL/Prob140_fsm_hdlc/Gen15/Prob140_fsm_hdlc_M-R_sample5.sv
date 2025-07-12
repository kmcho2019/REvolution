module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states
reg disc_reg, flag_reg, err_reg;
reg next_state;

// Define the states
localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TWO_ONES = 3'b010;
localparam THREE_ONES = 3'b011;
localparam FOUR_ONES = 3'b100;
localparam FIVE_ONES = 3'b101;
localparam SIX_ONES = 3'b110;
localparam SEVEN_ONES = 3'b111;

// Output logic
assign disc = (state == FIVE_ONES && ~in);
assign flag = (state == SIX_ONES && ~in);
assign err = (state == SEVEN_ONES);

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) state <= ONE;
                else state <= IDLE;
            end
            ONE: begin
                if (in) state <= TWO_ONES;
                else state <= IDLE;
            end
            TWO_ONES: begin
                if (in) state <= THREE_ONES;
                else state <= IDLE;
            end
            THREE_ONES: begin
                if (in) state <= FOUR_ONES;
                else state <= IDLE;
            end
            FOUR_ONES: begin
                if (in) state <= FIVE_ONES;
                else state <= IDLE;
            end
            FIVE_ONES: begin
                if (in) state <= SIX_ONES;
                else state <= IDLE;
            end
            SIX_ONES: begin
                if (in) state <= SEVEN_ONES;
                else state <= IDLE;
            end
            SEVEN_ONES: begin
                if (~in) state <= IDLE;
                else state <= SEVEN_ONES;
            end
        endcase
    end
end

// Simplify clock gating logic
reg clk_gated;
always @(posedge clk) begin
    if (reset) clk_gated <= 0;
    else if (state == IDLE) clk_gated <= 0;
    else clk_gated <= 1;
end

endmodule