module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states using parameters
parameter A = 3'b000, B = 3'b001, C = 3'b011, D = 3'b010, E = 3'b110, F = 3'b111;

// State register
reg [2:0] currentState, nextState;

// Combinational logic for next state
always @(*) begin
    case (currentState)
        A: nextState = (w)? A : B;
        B: nextState = (w)? D : C;
        C: nextState = (w)? D : E;
        D: nextState = (w)? A : F;
        E: nextState = (w)? D : E;
        F: nextState = (w)? D : C;
        default: nextState = A;
    endcase
end

// Combinational logic for output
assign z = (currentState[2]); // optimize output logic by checking only the most significant bit

// Sequential logic for updating state
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule