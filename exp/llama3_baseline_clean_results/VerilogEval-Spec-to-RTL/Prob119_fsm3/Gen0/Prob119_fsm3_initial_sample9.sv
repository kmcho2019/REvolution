module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

// Define the states as an enumeration for better readability
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Current state register
reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Handle any other states, if needed
    endcase
end

// State transition logic
always @(*) begin
    case (state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A; // Default to state A
    endcase
end

// Sequential logic for updating the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A; // Asynchronous reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule