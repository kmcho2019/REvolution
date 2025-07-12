module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using a hybrid encoding scheme
parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b011;
parameter D = 3'b100;
parameter E = 3'b101;
parameter F = 3'b110;

// Define the state register using the hybrid encoding scheme
reg [2:0] currentState;
reg [2:0] nextState;

// Output z logic
assign z = (currentState == E) || (currentState == F);

// Calculate the next state
wire [2:0] nextState_A = (w)? A : B;
wire [2:0] nextState_B = (w)? D : C;
wire [2:0] nextState_C = (w)? D : E;
wire [2:0] nextState_D = (w)? A : F;
wire [2:0] nextState_E = (w)? D : E;
wire [2:0] nextState_F = (w)? D : C;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else begin
        case (currentState)
            A: currentState <= nextState_A;
            B: currentState <= nextState_B;
            C: currentState <= nextState_C;
            D: currentState <= nextState_D;
            E: currentState <= nextState_E;
            F: currentState <= nextState_F;
            default: currentState <= A;
        endcase
    end
end

endmodule