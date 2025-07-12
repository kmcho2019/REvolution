module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding
localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

// Combinational logic for next state and output (Mealy FSM)
reg z_reg;
always @(*) begin
    case (state)
        A: begin
            z_reg = x;           // z=1 if x=1 else 0
            next_state = (x) ? B : A;
        end
        B: begin
            z_reg = ~x;          // z=1 if x=0 else 0
            next_state = B;
        end
        default: begin
            z_reg = 1'b0;
            next_state = A;
        end
    endcase
end

assign z = z_reg;

// Asynchronous active-high reset and state register update
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule