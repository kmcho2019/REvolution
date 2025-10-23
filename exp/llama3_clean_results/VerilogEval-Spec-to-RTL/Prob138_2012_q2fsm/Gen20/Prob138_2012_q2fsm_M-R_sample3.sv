module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states as an enumeration for clarity and ease of management
enum logic [2:0] {
    A = 3'b001,
    B = 3'b010,
    C = 3'b100,
    D = 3'b000,
    E = 3'b011,
    F = 3'b101
} current_state, next_state;

// State table using a case statement within an always block for readability
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
    begin
        case(current_state)
            A: current_state <= w? B : A;
            B: current_state <= w? C : D;
            C: current_state <= w? E : D;
            D: current_state <= w? F : A;
            E: current_state <= w? E : D;
            F: current_state <= w? C : D;
            default: current_state <= A; // Default state
        endcase
    end
end

// Output z using a continuous assignment for efficiency
assign z = (current_state == E || current_state == F);

endmodule