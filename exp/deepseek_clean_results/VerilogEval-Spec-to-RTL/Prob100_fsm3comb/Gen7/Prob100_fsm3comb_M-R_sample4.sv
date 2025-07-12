module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State encoding parameters
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State transition logic using continuous assignments
assign next_state = (state == A) ? (in ? B : A) :
                   (state == B) ? (in ? B : C) :
                   (state == C) ? (in ? D : A) :
                   (state == D) ? (in ? B : C) :
                   2'bxx; // Don't-care for undefined states

// Output logic - only high in state D
assign out = (state == D);

endmodule