module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Define the states
localparam A = 0;
localparam B = 1;
localparam C = 2;
localparam D = 3;
localparam E = 4;
localparam F = 5;

// Current state
reg [2:0] current_state;

// Next state
reg [2:0] next_state;

// Determine next state based on current state and input
always @(*) begin
    case(current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A; // Default to A
    endcase
end

// Determine output z based on current state
always @(*) begin
    case(current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0; // Default to 0
    endcase
end

// Update current state on positive edge of clock
always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule