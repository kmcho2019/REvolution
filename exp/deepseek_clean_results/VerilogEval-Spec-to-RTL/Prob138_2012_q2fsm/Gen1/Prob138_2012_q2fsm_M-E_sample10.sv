module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding where bit 2 indicates z output
    // States with z=1: E(4), F(5) - these have bit 2 set
    parameter [2:0] A = 3'b000;
    parameter [2:0] B = 3'b001;
    parameter [2:0] C = 3'b010;
    parameter [2:0] D = 3'b011;
    parameter [2:0] E = 3'b100;
    parameter [2:0] F = 3'b101;

    reg [2:0] state;

    // State transition ROM (current_state + w -> next_state)
    wire [2:0] next_state;
    assign next_state = 
        (state == A) ? (w ? B : A) :
        (state == B) ? (w ? C : D) :
        (state == C) ? (w ? E : D) :
        (state == D) ? (w ? F : A) :
        (state == E) ? (w ? E : D) :
        (state == F) ? (w ? C : D) : A;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z is simply the MSB of state (E and F have this bit set)
    assign z = state[2];

endmodule