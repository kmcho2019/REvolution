module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg [1:0] state, next_state;
localparam A = 2'b01, B = 2'b10;

// Next state and output logic
always @(*) begin
    case (state)
        A: begin
            if (x) next_state = B; else next_state = A;
            z = x ? 1'b1 : 1'b0;
        end
        B: begin
            next_state = B;
            z = ~x ? 1'b1 : 1'b0;
        end
        default: begin
            next_state = A;
            z = 1'b0;
        end
    endcase
end

// State register with async active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule