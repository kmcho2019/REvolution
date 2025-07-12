module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states using one-hot encoding
reg disc_reg, flag_reg, err_reg;

localparam IDLE = 3'b001;
localparam ONE = 3'b010;
localparam TWO_ONES = 3'b100;
localparam THREE_ONES = 3'b001; // merged with IDLE
localparam FOUR_ONES = 3'b010; // merged with ONE
localparam FIVE_ONES = 3'b100; // merged with TWO_ONES
localparam SIX_ONES = 3'b011;
localparam SEVEN_ONES = 3'b110;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

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
                if (in) state <= SIX_ONES;
                else state <= IDLE;
            end
            SIX_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                end
            end
            SEVEN_ONES: begin
                if (~in) state <= IDLE;
                else begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end
            end
            default: state <= IDLE; // handle invalid states
        endcase
    end
end

assign disc = (state == TWO_ONES && ~in)? 1 : 0;
assign flag = (state == SIX_ONES && ~in)? 1 : 0;
assign err = (state == SEVEN_ONES)? 1 : 0;

endmodule