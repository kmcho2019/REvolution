module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using one-hot encoding
parameter A = 4'b0001;
parameter B = 4'b0010;
parameter C = 4'b0100;
parameter D = 4'b1000;

// Define the state register using one-hot encoding
reg [3:0] currentState;

// Output z logic
assign z = (currentState == D);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else begin
        case (currentState)
            A: currentState <= w? A : B;
            B: currentState <= w? D : C;
            C: currentState <= w? D : A;
            D: currentState <= w? A : D;
            default: currentState <= A;
        endcase
    end
end

endmodule