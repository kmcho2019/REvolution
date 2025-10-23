module TopModule (
    input in,
    output out
);
    // Transmission gate implementation
    wire ngate, pgate;
    
    // Inverted control signals (assuming always enabled transmission gate)
    assign ngate = 1'b0;  // NMOS active low
    assign pgate = 1'b1;  // PMOS active high
    
    // Transmission gate behavior
    assign out = (pgate & ngate) ? 1'bz : in;
endmodule