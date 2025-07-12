module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    assign out = state[3]; // Out is high only when state is D

    assign next_state = (in ? 
                        (state == A ? B :
                         state == B ? B :
                         state == C ? D :
                         state == D ? B : 4'bxxxx) :
                        (state == A ? A :
                         state == B ? C :
                         state == C ? A :
                         state == D ? C : 4'bxxxx));

endmodule