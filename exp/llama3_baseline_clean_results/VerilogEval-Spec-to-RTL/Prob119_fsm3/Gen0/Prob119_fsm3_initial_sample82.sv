module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state register
reg [1:0] state;
reg [1:0] next_state;

// State transition table logic
always @(*) begin
    case (state)
        A: next_state = (in)? B : A;
        B: next_state = (in)? B : C;
        C: next_state = (in)? D : A;
        D: next_state = (in)? B : C;
        default: next_state = A;
    endcase
end

// Sequential logic for state update and output
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        out <= 0;
    end else begin
        state <= next_state;
        case (state)
            A, B, C: out <= 0;
            D: out <= 1;
            default: out <= 0;
        endcase
    end
end

endmodule