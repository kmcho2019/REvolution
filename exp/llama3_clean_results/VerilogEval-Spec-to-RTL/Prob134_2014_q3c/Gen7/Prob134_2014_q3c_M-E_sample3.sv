module TopModule(
    input  clk,
    input  x,
    input  [2:0] y, // This input seems to be mistakenly used in the original problem statement
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Initialize current_state (This might need to be adjusted based on the actual initial conditions)
initial current_state = 3'b000;

// Combinational logic for next state
always @ (*) begin
    case (current_state)
        3'b000: next_state = (x)? 3'b001 : 3'b000;
        3'b001: next_state = (x)? 3'b100 : 3'b001;
        3'b010: next_state = (x)? 3'b001 : 3'b010;
        3'b011: next_state = (x)? 3'b010 : 3'b001;
        3'b100: next_state = (x)? 3'b100 : 3'b011;
        default: next_state = 3'b000;
    endcase
end

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Output logic
assign z = (current_state == 3'b011 || current_state == 3'b100)? 1'b1 : 1'b0;
assign Y0 = next_state[0];

endmodule