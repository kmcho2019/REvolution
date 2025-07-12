module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state register
reg [1:0] current_state;

// Initialize the current state to A
initial current_state = A;

// Next state logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A
        current_state <= A;
    end else begin
        case(current_state)
            A: current_state <= (in) ? B : A;
            B: current_state <= (in) ? B : C;
            C: current_state <= (in) ? D : A;
            D: current_state <= (in) ? B : C;
            default: current_state <= A; // Should not happen
        endcase
    end
end

// Output logic
always @(current_state) begin
    case(current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Should not happen
    endcase
end

endmodule