module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State encoding with meaningful names
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Output is high only in state D
assign out = (state == D);

// State transition logic using nested ternary operators
assign next_state = (state == A) ? (in ? B : A) :
                    (state == B) ? (in ? B : C) :
                    (state == C) ? (in ? D : A) :
                    (state == D) ? (in ? B : C) :
                    2'b00; // Default to state A (though should never occur)

endmodule