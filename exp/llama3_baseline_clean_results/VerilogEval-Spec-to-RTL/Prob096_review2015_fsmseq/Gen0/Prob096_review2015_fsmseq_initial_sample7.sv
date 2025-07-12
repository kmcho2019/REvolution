module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [2:0] state;
reg [2:0] nextState;
reg start_shifting_reg;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S11 = 3'b010;
parameter S110 = 3'b011;
parameter S1101 = 3'b100;
parameter SFINAL = 3'b101;

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting_reg <= 0;
    end else begin
        state <= nextState;
        start_shifting_reg <= (state == S1101 || state == SFINAL) ? 1'b1 : 0;
    end
end

always @(*) begin
    case (state)
        S0: begin
            if (data) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (data) begin
                nextState = S11;
            end else begin
                nextState = S0;
            end
        end
        S11: begin
            if (data) begin
                nextState = S110;
            end else begin
                nextState = S0;
            end
        end
        S110: begin
            if (data) begin
                nextState = S0;
            end else begin
                nextState = S1101;
            end
        end
        S1101: begin
            nextState = SFINAL;
        end
        SFINAL: begin
            nextState = SFINAL;
        end
        default: begin
            nextState = S0;
        end
    endcase
end

assign start_shifting = start_shifting_reg;

endmodule