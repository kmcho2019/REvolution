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

// Clock gating
reg clk_gated;
assign clk_gated = clk & (~reset);

always @(posedge clk_gated) begin
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
                else begin
                    state <= IDLE;
                    disc_reg <= 1;
                end
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
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule