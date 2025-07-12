module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
typedef enum logic [3:0] {
    A = 4'd0,
    B = 4'd1,
    C = 4'd2,
    D = 4'd3,
    E = 4'd4,
    F = 4'd5
} state_t;

// Declare the current and next state variables
reg [3:0] current_state;
reg [3:0] next_state;

// Output z is determined by the current state
assign z = (current_state == E) || (current_state == F);

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

endmodule