module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states
reg [2:0] nextState; // next state

// Define the states
localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TWO_ONES = 3'b010;
localparam THREE_ONES = 3'b011;
localparam FOUR_ONES = 3'b100;
localparam FIVE_ONES = 3'b101;
localparam SIX_ONES = 3'b110;
localparam SEVEN_ONES = 3'b111;

// Update state
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
end

// Define next state
always @(*) begin
    case (state)
        IDLE: begin
            if (in) nextState = ONE;
            else nextState = IDLE;
        end
        ONE: begin
            if (in) nextState = TWO_ONES;
            else nextState = IDLE;
        end
        TWO_ONES: begin
            if (in) nextState = THREE_ONES;
            else nextState = IDLE;
        end
        THREE_ONES: begin
            if (in) nextState = FOUR_ONES;
            else nextState = IDLE;
        end
        FOUR_ONES: begin
            if (in) nextState = FIVE_ONES;
            else nextState = IDLE;
        end
        FIVE_ONES: begin
            if (in) nextState = SIX_ONES;
            else nextState = IDLE;
        end
        SIX_ONES: begin
            if (in) nextState = SEVEN_ONES;
            else nextState = IDLE;
        end
        SEVEN_ONES: begin
            if (~in) nextState = IDLE;
            else nextState = SEVEN_ONES;
        end
    endcase
end

// Define output signals
assign disc = (state == FIVE_ONES && ~in);
assign flag = (state == SIX_ONES && ~in);
assign err = (state == SEVEN_ONES);

endmodule