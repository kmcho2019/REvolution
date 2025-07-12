module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        A: begin
            if (r[0]) begin
                next_state <= B;
            end else if (r[1]) begin
                next_state <= C;
            end else if (r[2]) begin
                next_state <= D;
            end else begin
                next_state <= A;
            end
        end
        B: begin
            if (r[0]) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
        C: begin
            if (r[1]) begin
                next_state <= C;
            end else begin
                next_state <= A;
            end
        end
        D: begin
            next_state <= A; // Since device 2 has lowest priority, 
                             // it will only receive a grant if it is the only device making a request.
                             // Once it receives a grant, it will continue to receive the grant until it stops making a request.
                             // However, in the state diagram provided, there is no transition for state D.
                             // Therefore, we assume that state D will transition back to state A when device 2 stops making a request.
                             // But since device 2 has lowest priority, it will not receive a grant in state A if any other device is making a request.
                             // So, the transition from state D to state A is not a result of a request from device 2, but rather from the fact that device 2 stopped making a request.
        end
    endcase
end

// Describe FSM outputs
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0; // Since state D is not described in the state diagram, we assume g[2] is always 0.

endmodule