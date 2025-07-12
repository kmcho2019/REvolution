module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

// Sequential logic: state register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Combinational logic: next state and output
always @(*) begin
    case(state)
        A: begin
            if (x) 
                next_state = B;
            else
                next_state = A;
            z = x; // output for state A
        end
        B: begin
            next_state = B; // stay in B regardless of x
            z = ~x; // output for state B
        end
        default: begin
            next_state = A; // default safe state
            z = 1'b0;
        end
    endcase
end

endmodule