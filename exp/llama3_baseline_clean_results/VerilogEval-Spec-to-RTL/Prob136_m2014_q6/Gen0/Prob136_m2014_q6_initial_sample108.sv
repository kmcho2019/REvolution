module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state, next_state;

// State encoding
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @* begin
    case(state)
        A: if (!w) next_state = B; else next_state = A;
        B: if (!w) next_state = C; else next_state = D;
        C: if (!w) next_state = E; else next_state = D;
        D: if (!w) next_state = F; else next_state = A;
        E: if (w) next_state = D; else next_state = E;
        F: if (w) next_state = D; else next_state = C;
        default: next_state = A;
    endcase
end

// Output logic
always @* begin
    case(state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

endmodule