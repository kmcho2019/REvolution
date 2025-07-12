module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states using one-hot encoding
localparam A = 2'b01;
localparam B = 2'b10;
localparam C = 2'b11;
localparam D = 2'b00;

// Define the state register
reg [1:0] state;

// Combinational logic for next state
always_comb begin
    case (state)
        A: state <= in? B : A;
        B: state <= in? B : C;
        C: state <= in? D : A;
        D: state <= in? B : C;
        default: state <= A;
    endcase
end

// Sequential logic for state update with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        // Directly assign the next state
        case (state)
            A: state <= in? B : A;
            B: state <= in? B : C;
            C: state <= in? D : A;
            D: state <= in? B : C;
            default: state <= A;
        endcase
    end
end

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule