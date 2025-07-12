module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using binary encoding
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] currentState;

// Output z logic
assign z = (currentState == D);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        case (currentState)
            A: currentState <= w? A : B;
            B: currentState <= w? D : C;
            C: currentState <= w? D : D; // Simplified transition
            D: currentState <= w? A : D; // Simplified transition
            default: currentState <= A;
        endcase
    end
end

endmodule