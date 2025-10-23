module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define states
parameter A = 0, B = 1, C = 2, D = 3;

// State register
reg [1:0] state, next_state;

// Initialize state outputs
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 0; // Since there's no transition to state D in the diagram, we keep g[2] always 0

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table (next state logic)
always @(*) begin
    case (state)
        A: begin
            if (r[0]) begin
                next_state <= B;
            end else if (r[1]) begin
                next_state <= C;
            end else if (r[2]) begin
                next_state <= D; // Although this transition is not explicitly described, we keep it for completeness
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
        default: begin // This includes state D, which is not explicitly described in the transitions
            next_state <= A;
        end
    endcase
end

endmodule