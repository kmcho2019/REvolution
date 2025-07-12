module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

    // State transition logic
    wire [3:0] state_A = 4'b0001;
    wire [3:0] state_B = 4'b0010;
    wire [3:0] state_C = 4'b0100;
    wire [3:0] state_D = 4'b1000;

    assign next_state = (
        (state == state_A) ? (in ? state_B : state_A) :
        (state == state_B) ? (in ? state_B : state_C) :
        (state == state_C) ? (in ? state_D : state_A) :
        (state == state_D) ? (in ? state_B : state_C) :
        4'bxxxx
    );

endmodule