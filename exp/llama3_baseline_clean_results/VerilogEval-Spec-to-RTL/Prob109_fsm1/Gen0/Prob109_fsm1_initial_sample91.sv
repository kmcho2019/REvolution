module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] current_state; // 0 for state A, 1 for state B
reg [0:0] next_state;

always @(*) begin
    case(current_state)
        0: begin // State A
            if (!in)
                next_state = 1; // transition to B
            else
                next_state = 0; // stay in A
        end
        1: begin // State B
            if (!in)
                next_state = 0; // transition to A
            else
                next_state = 1; // stay in B
        end
        default: next_state = 1; // default to state B
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1; // asynchronously reset to state B
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        0: out = 0; // State A
        1: out = 1; // State B
        default: out = 1; // default to state B
    endcase
end

endmodule