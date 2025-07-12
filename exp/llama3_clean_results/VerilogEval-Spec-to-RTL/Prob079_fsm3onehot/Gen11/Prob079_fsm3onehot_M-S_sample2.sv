module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Directly implement state transitions based on the state and input
    assign next_state = (
        (!in && (state == 4'b0001)) ? 4'b0001 :
        ( in && (state == 4'b0001)) ? 4'b0010 :
        (!in && (state == 4'b0010)) ? 4'b0100 :
        ( in && (state == 4'b0010)) ? 4'b0010 :
        (!in && (state == 4'b0100)) ? 4'b0001 :
        ( in && (state == 4'b0100)) ? 4'b1000 :
        (!in && (state == 4'b1000)) ? 4'b0100 :
        ( in && (state == 4'b1000)) ? 4'b0010 : 4'bxxxx
    );

    // Output logic remains straightforward
    assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

endmodule