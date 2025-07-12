module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define states
parameter A = 2'b01;
parameter B = 2'b10;

reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
assign z = (current_state == A && x) || (current_state == B);

// Next state logic
always @(*) begin
    case(current_state)
        A: begin
            if (~x) next_state = A;
            else next_state = B;
        end
        B: begin
            next_state = B; // Regardless of x, next state is B
        end
        default: next_state = A; // Default or unknown states reset to A
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A; // Reset to state A on asynchronous reset
    end else begin
        current_state <= next_state;
    end
end

endmodule