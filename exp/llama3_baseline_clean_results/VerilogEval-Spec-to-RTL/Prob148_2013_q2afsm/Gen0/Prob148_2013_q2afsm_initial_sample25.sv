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
// Note: State D is not actually used in the transition logic based on the provided diagram

// Internal state variable
reg [1:0] state;

// Combinational logic for next state
reg [1:0] next_state;

always @(*) begin
    case(state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = C; // Assuming the intent was to go to a state where g[2] could be set, but following the exact diagram provided, this condition actually implies no change (staying in A) when considering the specified transitions.
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
        default: next_state = A; // Should never reach here, but for completeness
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // Since there's no state where g[2] is explicitly set to 1 in the provided transitions

endmodule