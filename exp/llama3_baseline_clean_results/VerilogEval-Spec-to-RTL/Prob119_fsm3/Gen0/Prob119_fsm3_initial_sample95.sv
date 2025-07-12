module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states as parameters for better readability
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Register to hold the current state
reg [1:0] state;

// Output logic
always @(state) begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Default to 0 for invalid states
    endcase
end

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state A
        state <= A;
    end else begin
        case (state)
            A: state <= in? B : A;
            B: state <= in? B : C;
            C: state <= in? D : A;
            D: state <= in? B : C;
            default: state <= A; // Default to A for invalid states
        endcase
    end
end

endmodule