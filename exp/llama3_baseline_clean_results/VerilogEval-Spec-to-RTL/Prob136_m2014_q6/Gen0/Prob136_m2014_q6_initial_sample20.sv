module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [5:0] current_state;
reg [5:0] next_state;

// Initialize the state machine
initial current_state = 6'b1; // Start in state A (6'b1 = 000001)

// Define the states
localparam A = 6'b100000;
localparam B = 6'b010000;
localparam C = 6'b001000;
localparam D = 6'b000100;
localparam E = 6'b000010;
localparam F = 6'b000001;

// Next state logic
always @(*) begin
    case(current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Output logic
always @(*) begin
    case(current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

// Sequential logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule