module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using Gray code encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// Define the state register using Gray code encoding
reg [2:0] state;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else
    case (state)
        A: state <= (w == 1)? A : B;
        B: state <= (w == 1)? D : C;
        C: state <= (w == 1)? D : E;
        D: state <= (w == 1)? A : F;
        E: state <= (w == 1)? D : E;
        F: state <= (w == 1)? D : C;
        default: state <= A;
    endcase
end

// Combinational logic for output z
always @(*) begin
    case (state)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule