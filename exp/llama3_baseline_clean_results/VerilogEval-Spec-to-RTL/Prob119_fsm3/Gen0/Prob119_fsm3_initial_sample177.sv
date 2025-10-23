module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 2'd0;
parameter B = 2'd1;
parameter C = 2'd2;
parameter D = 2'd3;

// Define state register
reg [1:0] state;
reg [1:0] next_state;

// Initialize state to A
initial state = A;

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Determine next state
always @* begin
    case (state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A;
    endcase
end

// Determine output
always @* begin
    case (state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule