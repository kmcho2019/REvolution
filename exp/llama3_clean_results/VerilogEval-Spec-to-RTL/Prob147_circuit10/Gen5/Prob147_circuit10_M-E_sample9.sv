module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

typedef enum logic [1:0] {STATE_0, STATE_1} state_type;

reg [1:0] state_reg; // Flip-flop to hold the state
assign state = state_reg[0]; // Make state observable

always @(posedge clk) begin
    case (state_reg)
        STATE_0: begin
            if (a && b) begin
                state_reg <= STATE_1;
            end else if (~a && b) begin
                state_reg <= STATE_1;
            end else if (~a && ~b && a) begin
                state_reg <= STATE_0;
            end else begin
                state_reg <= STATE_0;
            end
        end
        STATE_1: begin
            if (~a && ~b) begin
                state_reg <= STATE_0;
            end else if (a && ~b) begin
                state_reg <= STATE_1;
            end else begin
                state_reg <= STATE_1;
            end
        end
        default: begin
            state_reg <= STATE_0;
        end
    endcase
end

// Combinational logic for q based on b and state
assign q = (b && (state_reg == STATE_1 || a));

endmodule