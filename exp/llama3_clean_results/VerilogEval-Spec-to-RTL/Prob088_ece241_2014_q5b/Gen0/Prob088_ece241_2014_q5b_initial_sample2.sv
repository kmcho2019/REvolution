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

// Next state
reg [1:0] next_state;

// Output
reg z_reg;

// Initialize current state
initial current_state = A;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
        z_reg <= 1'b0;
    end else begin
        current_state <= next_state;
        z_reg <= (current_state == A && x) || (current_state == B);
    end
end

// Combinational logic
always @* begin
    case (current_state)
        A: next_state = x ? B : A;
        B: next_state = B;
        default: next_state = A;
    endcase
end

// Assign output
assign z = z_reg;

endmodule