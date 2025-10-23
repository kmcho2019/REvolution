module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Current state
reg state_t current_state;

// Output logic using continuous assignment
assign out = (current_state == D)? 1'b1 : 1'b0;

// Sequential logic and state transition logic combined
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= in? B : A;
            B: current_state <= in? B : C;
            C: current_state <= in? D : A;
            D: current_state <= in? B : C;
            default: current_state <= A;
        endcase
    end
end

endmodule