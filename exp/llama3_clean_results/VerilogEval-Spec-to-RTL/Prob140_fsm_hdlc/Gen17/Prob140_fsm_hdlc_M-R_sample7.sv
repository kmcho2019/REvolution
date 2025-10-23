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
reg [2:0] count; // counter for consecutive ones

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
        count <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONE;
                    count <= 1;
                end else begin
                    state <= IDLE;
                    count <= 0;
                end
            end
            ONE: begin
                if (in) begin
                    state <= TWO_ONES;
                    count <= count + 1;
                end else begin
                    state <= IDLE;
                    count <= 0;
                end
            end
            TWO_ONES: begin
                if (in) begin
                    state <= THREE_ONES;
                    count <= count + 1;
                end else begin
                    state <= IDLE;
                    count <= 0;
                end
            end
            THREE_ONES: begin
                if (in) begin
                    state <= FOUR_ONES;
                    count <= count + 1;
                end else begin
                    state <= IDLE;
                    count <= 0;
                end
            end
            FOUR_ONES: begin
                if (in) begin
                    state <= FIVE_ONES;
                    count <= count + 1;
                end else begin
                    state <= IDLE;
                    count <= 0;
                end
            end
            FIVE_ONES: begin
                if (in) begin
                    state <= SIX_ONES;
                    count <= count + 1;
                end else begin
                    state <= IDLE;
                    count <= 0;
                    disc_reg <= 1;
                end
            end
            SIX_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                    count <= count + 1;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    count <= 0;
                    flag_reg <= 1;
                end
            end
            SEVEN_ONES: begin
                if (~in) begin
                    state <= IDLE;
                    count <= 0;
                end else begin
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