module TopModule (
    input in,
    output out
);
    // Instantiate an inverter primitive to implement the NOT gate
    inv u_inv (.a(in), .y(out));
endmodule