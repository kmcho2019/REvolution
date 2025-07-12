module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

parameter IDLE = 0, ONES_1 = 1, ONES_2 = 2, ONES_3 = 3, ONES_4 = 4, ONES_5 = 5, ONES_6 = 6, ONES_7 = 7;

reg [2:0] state, next_state;
reg disc_reg, flag_reg, err_reg;

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

always @(*) begin
    case(state)
        IDLE: begin
            if(in == 1'b1) next_state = ONES_1;
            else next_state = IDLE;
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        ONES_1: begin
            if(in == 1'b1) next_state = ONES_2;
            else next_state = IDLE;
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        ONES_2: begin
            if(in == 1'b1) next_state = ONES_3;
            else next_state = IDLE;
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        ONES_3: begin
            if(in == 1'b1) next_state = ONES_4;
            else next_state = IDLE;
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        ONES_4: begin
            if(in == 1'b1) next_state = ONES_5;
            else next_state = IDLE;
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        ONES_5: begin
            if(in == 1'b1) next_state = ONES_6;
            else next_state = IDLE;
            disc_reg = 1'b1; // discard if 5 consecutive 1s followed by 0
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        ONES_6: begin
            if(in == 1'b1) next_state = ONES_7;
            else next_state = IDLE;
            disc_reg = 1'b0;
            flag_reg = 1'b1; // flag if 6 consecutive 1s followed by 0
            err_reg = 1'b0;
        end
        ONES_7: begin
            if(in == 1'b1) next_state = ONES_7;
            else next_state = IDLE;
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b1; // error if 7 or more consecutive 1s
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

endmodule