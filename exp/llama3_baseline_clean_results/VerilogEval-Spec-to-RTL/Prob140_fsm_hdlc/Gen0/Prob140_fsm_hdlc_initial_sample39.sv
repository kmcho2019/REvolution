module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [1:0] state; // S0, S1, S5, S6
reg [1:0] nextState;
reg disc_reg, flag_reg, err_reg;

always @(*) begin
    case(state)
        2'b00: begin // S0
            if (in) begin
                nextState = 2'b01; // S1
                disc_reg = 0;
                flag_reg = 0;
                err_reg = 0;
            end
            else begin
                nextState = 2'b00; // S0
                disc_reg = 0;
                flag_reg = 0;
                err_reg = 0;
            end
        end
        2'b01: begin // S1
            if (in) begin
                nextState = 2'b01; // S1
                disc_reg = 0;
                flag_reg = 0;
                err_reg = 0;
            end
            else begin
                nextState = 2'b00; // S0
                disc_reg = 0;
                flag_reg = 0;
                err_reg = 0;
            end
        end
        2'b10: begin // S5
            if (in) begin
                nextState = 2'b11; // S6
                disc_reg = 0;
                flag_reg = 0;
                err_reg = 0;
            end
            else begin
                nextState = 2'b00; // S0
                disc_reg = 1;
                flag_reg = 0;
                err_reg = 0;
            end
        end
        2'b11: begin // S6
            if (in) begin
                nextState = 2'b11; // S6
                disc_reg = 0;
                flag_reg = 0;
                err_reg = 1;
            end
            else begin
                nextState = 2'b00; // S0
                disc_reg = 0;
                flag_reg = 1;
                err_reg = 0;
            end
        end
        default: begin
            nextState = 2'b00; // S0
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // S0
    end
    else begin
        state <= nextState;
    end
    if (state == 2'b01) begin
        if (nextState == 2'b01) begin
            state <= 2'b10; // S5
        end
    end
    disc <= disc_reg;
    flag <= flag_reg;
    err <= err_reg;
end

always @(posedge clk) begin
    if (state == 2'b01) begin
        if (nextState == 2'b01) begin
            state <= 2'b10; // S5
        end
    end
end

always @(posedge clk) begin
    if (state == 2'b10) begin
        if (nextState == 2'b11) begin
            state <= 2'b11; // S6
        end
    end
end

endmodule