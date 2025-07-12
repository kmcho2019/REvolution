module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using binary encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Break down the states into subsets for modular design
// Subset 1: A, B, D
// Subset 2: C, E, F

// Define the state register using one-hot encoding for each subset
reg [2:0] subset1_state;
reg [2:0] subset2_state;

// Define the next state registers
reg [2:0] next_subset1_state;
reg [2:0] next_subset2_state;

// Modular state machine for Subset 1 (A, B, D)
always @(*) begin
    case (subset1_state)
        3'b001: next_subset1_state = (w == 1)? 3'b100 : 3'b010; // A to D or B
        3'b010: next_subset1_state = (w == 1)? 3'b100 : 3'b001; // B to D or A
        3'b100: next_subset1_state = (w == 1)? 3'b001 : 3'b100; // D to A or stay in subset
        default: next_subset1_state = 3'b001; // Default to A
    endcase
end

// Modular state machine for Subset 2 (C, E, F)
always @(*) begin
    case (subset2_state)
        3'b001: next_subset2_state = (w == 1)? 3'b100 : 3'b010; // C to E or F
        3'b010: next_subset2_state = (w == 1)? 3'b100 : 3'b001; // E to C or stay in subset
        3'b100: next_subset2_state = (w == 1)? 3'b001 : 3'b010; // F to C or E
        default: next_subset2_state = 3'b001; // Default to C
    endcase
end

// Interface logic between subsets
always @(*) begin
    if (subset1_state == 3'b100 && w == 0) begin // Transition from D to F
        subset1_state <= 3'b000;
        subset2_state <= 3'b100;
    end else if (subset2_state == 3'b100 && w == 1) begin // Transition from F to D
        subset1_state <= 3'b100;
        subset2_state <= 3'b000;
    end
end

// Combinational logic for output z
assign z = (subset2_state == 3'b010 || subset2_state == 3'b100); // z is high for E and F

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        subset1_state <= 3'b001; // Initialize to A
        subset2_state <= 3'b000;
    end else begin
        subset1_state <= next_subset1_state;
        subset2_state <= next_subset2_state;
    end
end

endmodule