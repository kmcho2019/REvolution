module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter STATE_A = 0;
parameter STATE_B = 1;

reg [0:0] current_state;
reg [0:0] next_state;

always @(*) begin
    case(current_state)
        STATE_A: begin
            if (in == 0) next_state = STATE_B;
            else next_state = STATE_A;
        end
        STATE_B: begin
            if (in == 0) next_state = STATE_A;
            else next_state = STATE_B;
        end
        default: next_state = STATE_B;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) current_state <= STATE_B;
    else current_state <= next_state;
end

always @(*) begin
    case(current_state)
        STATE_A: out = 0;
        STATE_B: out = 1;
        default: out = 1; // default to B
    endcase
end

endmodule