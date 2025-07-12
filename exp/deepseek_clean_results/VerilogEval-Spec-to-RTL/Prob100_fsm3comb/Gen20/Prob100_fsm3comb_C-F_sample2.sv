module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// State encodings with meaningful names
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Moore output - depends only on current state
assign out = (state == D); // Output 1 when in state D

// State transition logic with named states and comments
always @(*) begin
    case (state)
        A: next_state = in ? B : A; // State A: A->B if in=1, else stay A
        B: next_state = in ? B : C; // State B: B->B if in=1, else C
        C: next_state = in ? D : A; // State C: C->D if in=1, else A
        D: next_state = in ? B : C; // State D: D->B if in=1, else C
    endcase
end

endmodule