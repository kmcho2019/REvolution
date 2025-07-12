module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 6 states using binary encoding
reg disc_reg, flag_reg, err_reg;

// Define the states using binary encoding
localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TWO_ONES = 3'b010;
localparam THREE_ONES = 3'b011;
localparam FOUR_ONES = 3'b100;
localparam FIVE_ONES = 3'b101;

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
                if (in) begin
                    state <= FIVE_ONES;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                    if (state == FIVE_ONES && in == 0) begin
                        disc_reg <= 1;
                    end
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule