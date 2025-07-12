module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states as 2-bit values
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

// State register
reg [1:0] state;

// Next state logic
reg [1:0] next_state;
always_comb begin
    case (state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A;
    endcase
end

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 1'd0;
        D: out = 1'd1;
        default: out = 1'd0;
    endcase
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule