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

always @(*) begin
    case (state)
        3'b000: begin
            if (in) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b000;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        3'b001: begin
            if (in) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b000;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        3'b010: begin
            if (in) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b000;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        3'b011: begin
            if (in) begin
                nextState = 3'b100;
            end else begin
                nextState = 3'b000;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        3'b100: begin
            if (in) begin
                nextState = 3'b101;
                err_reg = 1'b1;
            end else begin
                nextState = 3'b000;
                disc_reg = 1'b1;
            end
            flag_reg = 1'b0;
        end
        3'b101: begin
            if (in) begin
                nextState = 3'b110;
                err_reg = 1'b1;
            end else begin
                nextState = 3'b000;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b1;
        end
        3'b110: begin
            if (in) begin
                nextState = 3'b110;
                err_reg = 1'b1;
            end else begin
                nextState = 3'b000;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
        end
    endcase
end

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