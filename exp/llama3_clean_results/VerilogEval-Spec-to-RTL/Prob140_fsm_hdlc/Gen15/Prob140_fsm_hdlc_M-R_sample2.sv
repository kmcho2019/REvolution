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
reg [2:0] count;

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
        count <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            count <= count + 1;
            case (count)
                5: state <= FIVE_ONES;
                6: state <= SIX_ONES;
                7: state <= SEVEN_ONES;
                default: state <= ONE;
            endcase
        end else begin
            count <= 0;
            case (state)
                FIVE_ONES: begin
                    state <= IDLE;
                    disc_reg <= 1;
                end
                SIX_ONES: begin
                    state <= IDLE;
                    flag_reg <= 1;
                end
                SEVEN_ONES: begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end
                default: state <= IDLE;
            endcase
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule