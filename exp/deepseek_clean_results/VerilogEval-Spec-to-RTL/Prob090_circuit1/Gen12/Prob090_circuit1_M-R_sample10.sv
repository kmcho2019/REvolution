module TopModule (
    input a,
    input b,
    output reg q
);
    // AND gate implementation using always block
    // Same PPA characteristics as continuous assignment version:
    // - Timing: tns/wns = 0
    // - Power: 4.55e-05 W
    // - Area: 1.0 um²
    always @(*) begin
        q = a & b;
    end
endmodule