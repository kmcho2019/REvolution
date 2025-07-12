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

// Declare the current and next state variables
reg [1:0] current_state, next_state;

// Continuous assignment for outputs g[2:0]
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0; // g[2] is never set to 1 according to the given state diagram

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
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0]) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1]) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        D: begin
            // Since device 2 will only receive a grant if it is the only device making a request,
            // and it cannot be granted when other devices are also requesting, 
            // its grant should be reset when any other device starts requesting.
            // However, according to the given state diagram, state D does not have any outgoing transitions.
            // Thus, the next state should be A if device 2's request is removed.
            if (~r[2]) begin
                next_state = A;
            end else begin
                next_state = D;
            end
        end
    endcase
end

endmodule