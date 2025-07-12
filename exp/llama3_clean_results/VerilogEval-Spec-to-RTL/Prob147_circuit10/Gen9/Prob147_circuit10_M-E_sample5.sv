module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

typedef enum logic [1:0] {
    S0,
    S1
} state_t;

state_t state_reg;
assign state = (state_reg == S0)? 1'b0 : 1'b1;

always @(posedge clk) begin
    case (state_reg)
        S0: if (~a && b) state_reg <= S1;
        S1: if (a && b) state_reg <= S0;
        default: state_reg <= state_reg;
    endcase
end

assign q = (state_reg == S1) || (state_reg == S0 && b);

endmodule