module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [3:0] state; // 4 bits to represent 7 states
reg disc_reg, flag_reg, err_reg;

// Define the states
localparam IDLE = 4'b0000;
localparam ONE = 4'b0001;
localparam TWO = 4'b0010;
localparam THREE = 4'b0011;
localparam FOUR = 4'b0100;
localparam FIVE = 4'b0101;
localparam SIX = 4'b0110;
localparam SEVEN = 4'b0111;

// Next state logic
reg [3:0] next_state;

always @(*) begin
    case (state)
        IDLE: next_state = in? ONE : IDLE;
        ONE: next_state = in? TWO : IDLE;
        TWO: next_state = in? THREE : IDLE;
        THREE: next_state = in? FOUR : IDLE;
        FOUR: next_state = in? FIVE : IDLE;
        FIVE: next_state = in? SIX : IDLE;
        SIX: next_state = in? SEVEN : IDLE;
        SEVEN: next_state = in? SEVEN : IDLE;
    endcase
end

// Output signal logic
always @(*) begin
    disc_reg = (state == FIVE &&!in);
    flag_reg = (state == SIX &&!in);
    err_reg = (state == SIX && in) || (state == SEVEN);
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

// Output signal assignment
assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule