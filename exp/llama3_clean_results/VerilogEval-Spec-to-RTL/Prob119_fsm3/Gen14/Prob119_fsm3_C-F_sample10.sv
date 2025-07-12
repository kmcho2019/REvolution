module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// Define states
parameter A = 2'd0;
parameter B = 2'd1;
parameter C = 2'd2;
parameter D = 2'd3;

// State register
reg [1:0] state;

// Next state logic
always_comb begin
    case (state)
        A: state <= in? B : A;
        B: state <= in? B : C;
        C: state <= in? D : A;
        D: state <= in? B : C;
        default: state <= A;
    endcase
end

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        // State transition is handled in the always_comb block
    end
end

endmodule