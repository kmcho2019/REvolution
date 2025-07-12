module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Using one-hot encoding for simplicity and timing benefits

localparam IDLE = 3'b001;
localparam ONE = 3'b010;
localparam TWO_ONES = 3'b100;
localparam THREE_ONES = 3'b000;
localparam FOUR_ONES = 3'b011;
localparam FIVE_ONES = 3'b101;
localparam SIX_ONES = 3'b110;
localparam SEVEN_ONES = 3'b111;

// State machine logic using combinational assign statements
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: state <= in ? ONE : IDLE;
            ONE: state <= in ? TWO_ONES : IDLE;
            TWO_ONES: state <= in ? THREE_ONES : IDLE;
            THREE_ONES: state <= in ? FOUR_ONES : IDLE;
            FOUR_ONES: state <= in ? FIVE_ONES : IDLE;
            FIVE_ONES: state <= in ? SIX_ONES : IDLE;
            SIX_ONES: state <= in ? SEVEN_ONES : (in == 0 ? IDLE : SIX_ONES);
            SEVEN_ONES: state <= in ? SEVEN_ONES : IDLE;
            default: state <= IDLE;
        endcase
    end
end

// Directly drive outputs based on state and input
assign disc = (state == FIVE_ONES && ~in);
assign flag = (state == SIX_ONES && ~in);
assign err = (state == SEVEN_ONES);

endmodule