module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

// Declare the current state and next state registers
reg [1:0] current_state;
reg [1:0] next_state;

// Initialize the current state
initial current_state = A;

// State machine logic
always @(*) begin
    case(current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A; // Default to A if current_state is unknown
    endcase
end

// Output logic (Moore machine, output depends only on state)
always @(*) begin
    case(current_state)
        A, B, C: out = 1'd0;
        D: out = 1'd1;
        default: out = 1'd0; // Default output if current_state is unknown
    endcase
end

// Sequential logic (positive edge triggered, asynchronous reset)
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule