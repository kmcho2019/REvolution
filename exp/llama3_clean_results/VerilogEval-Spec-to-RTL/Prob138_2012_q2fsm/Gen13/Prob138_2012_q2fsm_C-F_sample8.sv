module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Internal state signal
reg [2:0] state; // 3-bit state register

// State machine
always @ (posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        case (state)
            A: state <= w? B : A; // State A
            B: state <= w? C : D; // State B
            C: state <= w? E : D; // State C
            D: state <= w? F : A; // State D
            E: state <= w? E : D; // State E
            F: state <= w? C : D; // State F
            default: state <= A; // Default to state A
        endcase
    end
end

// Output z
assign z = (state == E || state == F); // z is high when state is E or F

endmodule