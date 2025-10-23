module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Enumerate states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;
parameter E = 3'b100;
parameter F = 3'b101;

reg [2:0] state, nextState;

// Combinational logic for the state table
always @(*) begin
    case(state)
        A: begin
            if(w) nextState = B;
            else   nextState = A;
        end
        B: begin
            if(w) nextState = C;
            else   nextState = D;
        end
        C: begin
            if(w) nextState = E;
            else   nextState = D;
        end
        D: begin
            if(w) nextState = F;
            else   nextState = A;
        end
        E: begin
            if(w) nextState = E;
            else   nextState = D;
        end
        F: begin
            if(w) nextState = C;
            else   nextState = D;
        end
        default: nextState = A; // Default to state A
    endcase
end

// Sequential logic for state flip-flops
always @(posedge clk) begin
    if(reset) state = A;
    else state = nextState;
end

// Continuous assignment for output z, based on state
assign z = state[2];

endmodule