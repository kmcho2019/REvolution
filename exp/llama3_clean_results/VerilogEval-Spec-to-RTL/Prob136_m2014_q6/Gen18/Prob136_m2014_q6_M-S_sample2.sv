module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using 2-bit encoding
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the state register
reg [1:0] state;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else begin
        case (state)
            A: state <= (w == 1)? A : B;
            B: state <= (w == 1)? D : C;
            C: state <= (w == 1)? D : C;
            D: state <= (w == 1)? A : D;
            default: state <= A;
        endcase
    end
end

// Combinational logic for output z
assign z = (state == C || state == D);

endmodule