module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [1:0] state; // S0, S1, S2, S3
reg [1:0] nextState;
reg disc_reg;
reg flag_reg;
reg err_reg;

// State encoding:
// 2'b00: S0
// 2'b01: S1
// 2'b10: S2
// 2'b11: S3

always @(*) begin
    case (state)
        2'b00: begin // S0
            if (in) begin
                nextState = 2'b01;
            end else begin
                nextState = 2'b00;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        2'b01: begin // S1
            if (in) begin
                nextState = 2'b10;
            end else begin
                nextState = 2'b00;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        2'b10: begin // S2
            if (in) begin
                nextState = 2'b11;
            end else begin
                nextState = 2'b00;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        2'b11: begin // S3
            if (in) begin
                nextState = 2'b11;
                err_reg = 1'b1;
            end else begin
                nextState = 2'b00;
                disc_reg = 1'b1;
            end
            flag_reg = (state == 2'b11 && in == 1'b0) ? 1'b1 : 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
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