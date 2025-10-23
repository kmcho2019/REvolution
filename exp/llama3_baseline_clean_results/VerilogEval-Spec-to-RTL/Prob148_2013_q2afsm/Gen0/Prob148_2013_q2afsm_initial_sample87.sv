module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;

// Declare current state and next state variables
reg [2:0] current_state;
reg [2:0] next_state;

// Assign outputs based on current state
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0;  // Since state D is not used in the given state diagram

// Always block for state flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Always block for next state logic
always @(*) begin
    case (current_state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        D: begin
            // Since state D is not used in the given state diagram, assign next state as A
            next_state = A;
        end
        default: begin
            next_state = A;
        end
    endcase
end

endmodule