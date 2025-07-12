module TransmissionGate (
    input in,
    input en,
    output out
);
    // Model a transmission gate behavior
    assign out = en ? in : 1'bz;
endmodule

module TopModule (
    input in,
    output out
);
    // Instantiate transmission gate with always-enabled control
    TransmissionGate tg (
        .in(in),
        .en(1'b1),  // Always enabled
        .out(out)
    );
endmodule