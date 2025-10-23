module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output reg [2:0] g
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Combinational logic for next state
always @(*) begin
    case (current_state)
        A: begin
            if (r[0] == 1) next_state = B;
            else if (r[1] == 1) next_state = C;
            else next_state = A;
        end
        B: begin
            if (r[0] == 1) next_state = B;
            else next_state = A;
        end
        C: begin
            if (r[1] == 1) next_state = C;
            else next_state = A;
        end
        default: next_state = A;
    endcase
end

// Sequential logic for current state
always @(posedge clk) begin
    if (~resetn) current_state <= A;
    else current_state <= next_state;
end

// Continuous assignment for output g
always @(*) begin
    case (current_state)
        B: begin g = 4'b100; end
        C: begin g = 4'b010; end
        default: g = 4'b000;
    endcase
end

endmodule