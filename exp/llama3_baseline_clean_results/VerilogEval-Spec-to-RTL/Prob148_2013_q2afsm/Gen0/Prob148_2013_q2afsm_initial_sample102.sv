module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1) next_state = B;
            else if (r[1] == 1) next_state = C;
            else if (r[2] == 1) next_state = D;
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
        D: begin
            // We actually never go to state D according to the diagram
            next_state = A;
        end
        default: next_state = A;
    endcase
end

// State flip-flop
always @(posedge clk) begin
    if (~resetn) state <= A;
    else state <= next_state;
end

// Output logic
always @(*) begin
    case (state)
        A: g = 3'b000;
        B: g = 3'b100;
        C: g = 3'b010;
        D: g = 3'b000; // We actually never go to state D according to the diagram
        default: g = 3'b000;
    endcase
end

endmodule