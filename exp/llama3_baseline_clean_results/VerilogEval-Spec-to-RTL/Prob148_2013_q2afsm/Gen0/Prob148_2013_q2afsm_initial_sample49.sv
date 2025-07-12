module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define the state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Declare the current and next states
reg [1:0] current_state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
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
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                // Since state D's behavior is the same as A when all r[i] are 0,
                // we don't need an explicit state D for this condition.
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

// Output logic
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0; // Since we're not using state D, g[2] remains 0

endmodule