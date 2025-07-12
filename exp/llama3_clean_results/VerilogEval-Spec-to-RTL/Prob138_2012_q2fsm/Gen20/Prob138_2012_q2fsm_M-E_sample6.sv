module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State encoding
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Signals for state machine
reg [2:0] state;
reg [2:0] next_state;

// Module for states A, B, C, D
module Cluster1(
    input  clk,
    input  reset,
    input  w,
    input  [2:0] state,
    output reg [2:0] next_state
);
    always @ (*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            default: next_state = A;
        endcase
    end
endmodule

// Module for states E, F
module Cluster2(
    input  clk,
    input  reset,
    input  w,
    input  [2:0] state,
    output reg [2:0] next_state
);
    always @ (*) begin
        case (state)
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = D;
        endcase
    end
endmodule

// Instantiations
Cluster1 cluster1(
    .clk(clk),
    .reset(reset),
    .w(w),
    .state(state),
    .next_state(next_state)
);

Cluster2 cluster2(
    .clk(clk),
    .reset(reset),
    .w(w),
    .state(state),
    .next_state(next_state)
);

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        if (state == E || state == F) begin
            // Use next_state from Cluster2
            state <= cluster2.next_state;
        end else begin
            // Use next_state from Cluster1
            state <= cluster1.next_state;
        end
    end
end

// Output z
assign z = state[2]; // z is high when state is E or F

endmodule