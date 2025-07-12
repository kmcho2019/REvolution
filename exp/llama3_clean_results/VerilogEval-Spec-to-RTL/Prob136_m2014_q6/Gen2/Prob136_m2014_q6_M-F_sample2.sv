module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states as local parameters
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// State register
reg [2:0] state;
reg [2:0] next_state;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Sequential logic to update the current state and output z
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
        z <= 0;
    end else begin
        state <= next_state;
        case (state)
            A, B, C, D: z <= 0;
            E, F: z <= 1;
            default: z <= 0;
        endcase
    end
end

endmodule