module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define states
parameter A = 2'b01;
parameter B = 2'b10;

// Current state
reg [1:0] current_state;

// Initialize current state
initial current_state = A;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= (x) ? B : A;
            B: current_state <= B;
            default: current_state <= A;
        endcase
    end
end

// Combinational logic for output z
assign z = (current_state == B) || (current_state == A && x);

endmodule