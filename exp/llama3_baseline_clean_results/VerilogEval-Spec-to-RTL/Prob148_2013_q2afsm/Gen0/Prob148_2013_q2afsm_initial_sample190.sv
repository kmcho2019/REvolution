module TopModule(
    input  clk,
    input  resetn,
    input [2:0] r,  // r[0], r[1], r[2]
    output [2:0] g  // g[0], g[1], g[2]
);

reg [1:0] current_state;  // State register
reg [1:0] next_state;    // Next state register

// Define state codes
parameter A = 2'd0, B = 2'd1, C = 2'd2;

// Continuous assignment for outputs based on the current state
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0;  // Since there's no state defined for g[2] = 1 in the given problem

// Next state logic (Combinational)
always @(*) begin
    case(current_state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                // Assuming it should go to a state where g[2] is set, but since there's no such state defined, 
                // we'll leave it in state A or handle it according to the designer's intention.
                next_state = A;
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
        default: next_state = A;
    endcase
end

// State flip-flops (Sequential)
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule