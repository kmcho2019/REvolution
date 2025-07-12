module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Current state register
reg [2:0] currentState;
reg [2:0] nextState;

// Output logic
always @(*) begin
    case(currentState)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0; // Default to 0 for unknown states
    endcase
end

// Next state logic
always @(*) begin
    case(currentState)
        A: nextState = (w) ? A : B;
        B: nextState = (w) ? D : C;
        C: nextState = (w) ? D : E;
        D: nextState = (w) ? A : F;
        E: nextState = (w) ? D : E;
        F: nextState = (w) ? D : C;
        default: nextState = A; // Default to A for unknown states
    endcase
end

// State register update
always @(posedge clk or posedge reset) begin
    if(reset) begin
        currentState <= A; // Reset to state A
    end else begin
        currentState <= nextState;
    end
end

endmodule