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
reg disc_reg, flag_reg, err_reg;

// Output logic
assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

always @(*) begin
    disc_reg = 1'b0;
    flag_reg = 1'b0;
    err_reg = 1'b0;

    case (state)
        3'b101: // S5
            if (!in) begin
                disc_reg = 1'b1;
            end
        3'b110: // S6
            if (!in) begin
                flag_reg = 1'b1;
            end
        3'b111: // S7
            err_reg = 1'b1;
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        3'b000: // S0
            if (in) begin
                nextState = 3'b001; // S1
            end else begin
                nextState = 3'b000; // S0
            end
        3'b001, 3'b010, 3'b011, 3'b100, 3'b101: // S1 to S5
            if (in) begin
                nextState = state + 1;
            end else begin
                nextState = 3'b000; // S0
            end
        3'b110: // S6
            if (!in) begin
                nextState = 3'b000; // S0
            end else begin
                nextState = 3'b111; // S7
            end
        3'b111: // S7
            if (in) begin
                nextState = 3'b111; // S7
            end else begin
                nextState = 3'b001; // S1
            end
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // S0
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end else begin
        state <= nextState;
    end
end

endmodule