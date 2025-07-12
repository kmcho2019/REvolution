module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
reg [2:0] nextState;
reg disc_reg;
reg flag_reg;
reg err_reg;

// Moore-type FSM state machine
always @(*) begin
    case(state)
        3'b000: begin // S0
            if (in) begin
                nextState = 3'b001;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = 3'b000;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        3'b001: begin // S1
            if (in) begin
                nextState = 3'b010;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = 3'b000;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        3'b010: begin // S2
            if (in) begin
                nextState = 3'b011;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = 3'b000;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        3'b011: begin // S3
            if (in) begin
                nextState = 3'b100;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = 3'b000;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        3'b100: begin // S4
            if (in) begin
                nextState = 3'b101;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = 3'b000;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        3'b101: begin // S5
            if (in) begin
                nextState = 3'b110;
                disc_reg = 1'b1;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = 3'b000;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        3'b110: begin // S6
            if (in) begin
                nextState = 3'b111;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b1;
            end else begin
                nextState = 3'b000;
                disc_reg = 1'b0;
                flag_reg = 1'b1;
                err_reg = 1'b0;
            end
        end
        3'b111: begin // S7
            if (in) begin
                nextState = 3'b111;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b1;
            end else begin
                nextState = 3'b000;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
    endcase
end

// sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end

endmodule