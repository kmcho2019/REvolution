module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// One-hot state encoding
localparam A = 4'b0001,
           B = 4'b0010,
           C = 4'b0100,
           D = 4'b1000;

reg [3:0] state, next_state;

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Combined next state and output logic (Moore output depends only on current state)
always @(*) begin
    // Default next_state to prevent latches
    next_state = 4'b0000;

    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// Output combinational from current state (Moore)
assign out = (state == D);

endmodule