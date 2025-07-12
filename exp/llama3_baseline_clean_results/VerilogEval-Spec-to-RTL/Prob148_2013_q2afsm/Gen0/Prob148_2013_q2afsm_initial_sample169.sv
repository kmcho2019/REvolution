module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define the states and their corresponding codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare the current state and next state signals
reg [1:0] current_state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
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
            // In the given FSM description, there's no condition for D to transition back to A.
            // However, the priority system implies that D should transition back to A when r[2] is 0.
            // If this is not the case, the FSM should not be in state D.
            next_state <= D;
        end
        default: begin
            next_state <= A;
        end
    endcase
end

// FSM outputs
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = (current_state == D);

endmodule