module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [5:0] current_state;
reg [5:0] next_state;

// One-hot encoding for states: A, B, C, D, E, F
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

always @(*) begin
    case(current_state)
        A: begin
            if(w == 1'b1) next_state = A;
            else next_state = B;
        end
        B: begin
            if(w == 1'b1) next_state = D;
            else next_state = C;
        end
        C: begin
            if(w == 1'b1) next_state = D;
            else next_state = E;
        end
        D: begin
            if(w == 1'b1) next_state = A;
            else next_state = F;
        end
        E: begin
            if(w == 1'b1) next_state = D;
            else next_state = E;
        end
        F: begin
            if(w == 1'b1) next_state = D;
            else next_state = C;
        end
        default: next_state = A;
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) current_state <= A;
    else current_state <= next_state;
end

assign z = (current_state == E) || (current_state == F);

endmodule