module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [5:0] current_state;
reg [5:0] next_state;

// One-hot encoding for states
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// Initialize the state machine to state A
initial current_state = A;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        A: if(w == 1'b0) next_state = B;
           else next_state = A;

        B: if(w == 1'b0) next_state = C;
           else next_state = D;

        C: if(w == 1'b0) next_state = E;
           else next_state = D;

        D: if(w == 1'b0) next_state = F;
           else next_state = A;

        E: if(w == 1'b1) next_state = E;
           else next_state = D;

        F: if(w == 1'b1) next_state = C;
           else next_state = D;

        default: next_state = A;
    endcase
end

// Output z is always 0 for states A, B, C, D and always 1 for states E, F
assign z = (current_state == E) || (current_state == F);

endmodule