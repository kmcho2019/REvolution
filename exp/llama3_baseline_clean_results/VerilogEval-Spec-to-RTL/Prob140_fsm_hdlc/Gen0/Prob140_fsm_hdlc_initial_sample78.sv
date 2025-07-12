module TopModule(
    input       clk,
    input       reset,
    input       in,
    output      disc,
    output      flag,
    output      err
);

parameter   IDLE     = 4'd0;
parameter   ONE      = 4'd1;
parameter   TWO      = 4'd2;
parameter   THREE    = 4'd3;
parameter   FOUR     = 4'd4;
parameter   FIVE     = 4'd5;
parameter   SIX      = 4'd6;

reg [3:0]   state, next_state;
reg         disc_reg, flag_reg, err_reg;

always @(*) begin
    case(state)
        IDLE: begin
            if (in) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        ONE: begin
            if (in) begin
                next_state = TWO;
            end else begin
                next_state = IDLE;
            end
        end
        TWO: begin
            if (in) begin
                next_state = THREE;
            end else begin
                next_state = IDLE;
            end
        end
        THREE: begin
            if (in) begin
                next_state = FOUR;
            end else begin
                next_state = IDLE;
            end
        end
        FOUR: begin
            if (in) begin
                next_state = FIVE;
            end else begin
                next_state = IDLE;
            end
        end
        FIVE: begin
            if (in) begin
                next_state = SIX;
            end else begin
                next_state = IDLE;
                disc_reg = 1'b1; // signal discard
            end
        end
        SIX: begin
            if (in) begin
                next_state = SIX;
                err_reg = 1'b1; // signal error
            end else begin
                next_state = IDLE;
                flag_reg = 1'b1; // signal flag
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end else begin
        state <= next_state;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end
end

endmodule