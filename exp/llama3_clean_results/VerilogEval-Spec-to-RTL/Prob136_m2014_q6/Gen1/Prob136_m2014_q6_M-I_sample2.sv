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

// Combinational logic to determine the next state
always_comb begin
    case (state)
        A: state = w ? A : B;
        B: state = w ? D : C;
        C: state = w ? D : E;
        D: state = w ? A : F;
        E: state = w ? D : E;
        F: state = w ? D : C;
        default: state = A;
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
        z <= 0;
    end else begin
        case (state)
            A, B, C, D: z <= 0;
            E, F: z <= 1;
            default: z <= 0;
        endcase
    end
end

// Update the state on clock edge
always_ff @(posedge clk) begin
    state <= state;
end

endmodule