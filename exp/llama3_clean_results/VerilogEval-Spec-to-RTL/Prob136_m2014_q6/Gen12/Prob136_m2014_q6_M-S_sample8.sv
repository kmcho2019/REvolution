module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using gray code encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// State register
reg [2:0] state;

// Combinational logic for next state
always @(*) begin
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

// Combinational logic for output z
assign z = (state == E || state == F) ? 1 : 0;

// Update the state on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) state <= A;
    else // Do nothing as next state is already calculated
end

endmodule