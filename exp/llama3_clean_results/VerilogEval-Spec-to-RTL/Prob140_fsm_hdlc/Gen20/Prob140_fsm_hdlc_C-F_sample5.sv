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

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        // Update output registers only when necessary
        if (state == FIVE_ONES && ~in) disc_reg <= 1;
        else if (state == SIX_ONES && ~in) flag_reg <= 1;
        else if (state == SIX_ONES && in) err_reg <= 1;
        else if (state == SEVEN_ONES) err_reg <= 1;
        else begin
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end

        // Simplified state transitions
        case (state)
            IDLE: state <= in ? ONE : IDLE;
            ONE: state <= in ? TWO_ONES : IDLE;
            TWO_ONES: state <= in ? THREE_ONES : IDLE;
            THREE_ONES: state <= in ? FOUR_ONES : IDLE;
            FOUR_ONES: state <= in ? FIVE_ONES : IDLE;
            FIVE_ONES: state <= in ? SIX_ONES : IDLE;
            SIX_ONES: state <= in ? SEVEN_ONES : (in ? SEVEN_ONES : IDLE);
            SEVEN_ONES: state <= in ? SEVEN_ONES : IDLE;
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule