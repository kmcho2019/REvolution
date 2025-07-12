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
parameter E = 2'b12; // Note: Since we only need 4 states, we'll use E and F as 2'b12 and 2'b13, respectively, for simplicity in this example
parameter F = 2'b13;

// Define the state register
reg [1:0] state;

// State transition logic using assign
always @(posedge clk) begin
    if (reset) state <= A;
    else begin
        case (state)
            A: state <= w ? A : B;
            B: state <= w ? D : C;
            C: state <= w ? D : E;
            D: state <= w ? A : F;
            E: state <= w ? D : E;
            F: state <= w ? D : C;
            default: state <= A;
        endcase
    end
end

// Output logic for z
assign z = (state == E) || (state == F);

endmodule