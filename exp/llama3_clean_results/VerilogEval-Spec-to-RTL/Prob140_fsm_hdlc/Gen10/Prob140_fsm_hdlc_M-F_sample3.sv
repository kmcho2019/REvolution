module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [3:0] state; // 4 bits to represent 16 states

// Define the states
localparam IDLE = 4'b0000;
localparam ONE = 4'b0001;
localparam TWO_ONES = 4'b0010;
localparam THREE_ONES = 4'b0011;
localparam FOUR_ONES = 4'b0100;
localparam FIVE_ONES = 4'b0101;
localparam FIVE_ONES_DISC = 4'b0110;
localparam SIX_ONES = 4'b0111;
localparam SEVEN_ONES = 4'b1000;
localparam FLAG = 4'b1001;

reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in) state <= ONE;
                else state <= IDLE;
                disc_reg <= 1'b0;
                flag_reg <= 1'b0;
                err_reg <= 1'b0;
            end
            ONE: begin
                if (in) state <= TWO_ONES;
                else state <= IDLE;
                disc_reg <= 1'b0;
                flag_reg <= 1'b0;
                err_reg <= 1'b0;
            end
            TWO_ONES: begin
                if (in) state <= THREE_ONES;
                else state <= IDLE;
                disc_reg <= 1'b0;
                flag_reg <= 1'b0;
                err_reg <= 1'b0;
            end
            THREE_ONES: begin
                if (in) state <= FOUR_ONES;
                else state <= IDLE;
                disc_reg <= 1'b0;
                flag_reg <= 1'b0;
                err_reg <= 1'b0;
            end
            FOUR_ONES: begin
                if (in) state <= FIVE_ONES;
                else state <= IDLE;
                disc_reg <= 1'b0;
                flag_reg <= 1'b0;
                err_reg <= 1'b0;
            end
            FIVE_ONES: begin
                if (in) state <= SIX_ONES;
                else state <= FIVE_ONES_DISC;
                disc_reg <= 1'b0;
                flag_reg <= 1'b0;
                err_reg <= 1'b0;
            end
            FIVE_ONES_DISC: begin
                state <= IDLE;
                disc_reg <= 1'b1;
                flag_reg <= 1'b0;
                err_reg <= 1'b0;
            end
            SIX_ONES: begin
                if (in) state <= SEVEN_ONES;
                else state <= FLAG;
                disc_reg <= 1'b0;
                flag_reg <= 1'b0;
                err_reg <= 1'b0;
            end
            SEVEN_ONES: begin
                if (~in) state <= IDLE;
                else state <= SEVEN_ONES;
                disc_reg <= 1'b0;
                flag_reg <= 1'b0;
                err_reg <= 1'b1;
            end
            FLAG: begin
                state <= IDLE;
                disc_reg <= 1'b0;
                flag_reg <= 1'b1;
                err_reg <= 1'b0;
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule