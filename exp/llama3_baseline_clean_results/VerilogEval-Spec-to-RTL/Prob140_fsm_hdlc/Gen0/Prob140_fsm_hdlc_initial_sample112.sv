module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

parameter IDLE = 8'd0;
parameter ONE_1 = 8'd1;
parameter ONE_2 = 8'd2;
parameter ONE_3 = 8'd3;
parameter ONE_4 = 8'd4;
parameter ONE_5 = 8'd5;
parameter ONE_6 = 8'd6;
parameter ERROR = 8'd7;

reg [7:0] state;
reg [7:0] next_state;
reg disc_reg;
reg flag_reg;
reg err_reg;

always @(*) begin
    case (state)
        IDLE: begin
            if (in) next_state = ONE_1;
            else next_state = IDLE;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        ONE_1: begin
            if (in) next_state = ONE_2;
            else next_state = IDLE;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        ONE_2: begin
            if (in) next_state = ONE_3;
            else next_state = IDLE;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        ONE_3: begin
            if (in) next_state = ONE_4;
            else next_state = IDLE;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        ONE_4: begin
            if (in) next_state = ONE_5;
            else next_state = IDLE;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        ONE_5: begin
            if (in) next_state = ONE_6;
            else next_state = IDLE;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        ONE_6: begin
            if (in) next_state = ERROR;
            else begin
                next_state = IDLE;
                disc_reg = 1;
            end
            flag_reg = 0;
            err_reg = 0;
        end
        ERROR: begin
            if (in) next_state = ERROR;
            else next_state = IDLE;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 1;
        end
        default: begin
            next_state = IDLE;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
    endcase

    if (state == ONE_6 && in == 1 && next_state == ERROR) begin
        flag_reg = 1;
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        state <= next_state;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end

endmodule