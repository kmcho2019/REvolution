module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states using binary encoding
reg disc_reg, flag_reg, err_reg;

// Define the states using binary encoding
localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TWO_ONES = 3'b010;
localparam THREE_ONES = 3'b011;
localparam FOUR_ONES = 3'b100;
localparam FIVE_ONES = 3'b101;
localparam SIX_ONES = 3'b110;
localparam SEVEN_ONES = 3'b111;

// Next state logic
reg [2:0] next_state;
always @(*) begin
    case (state)
        IDLE: next_state = in ? ONE : IDLE;
        ONE: next_state = in ? TWO_ONES : IDLE;
        TWO_ONES: next_state = in ? THREE_ONES : IDLE;
        THREE_ONES: next_state = in ? FOUR_ONES : IDLE;
        FOUR_ONES: next_state = in ? FIVE_ONES : IDLE;
        FIVE_ONES: next_state = in ? SIX_ONES : IDLE;
        SIX_ONES: next_state = in ? SEVEN_ONES : IDLE;
        SEVEN_ONES: next_state = in ? SEVEN_ONES : IDLE;
    endcase
end

// Output logic
always @(*) begin
    disc_reg = 0;
    flag_reg = 0;
    err_reg = 0;
    case (state)
        FIVE_ONES: if (~in) disc_reg = 1;
        SIX_ONES: if (~in) flag_reg = 1;
        SEVEN_ONES: err_reg = 1;
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        state <= next_state;
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule