module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Internal registers to hold the staged values
reg reg_p;
reg reg_q;

// Initialize outputs and internal registers to unknown (x) to match waveform initial state
initial begin
    p = 1'bx;
    q = 1'bx;
    reg_p = 1'bx;
    reg_q = 1'bx;
end

always @(posedge clock) begin
    reg_q <= reg_p;   // Delay reg_p by one clock cycle
    reg_p <= a;       // Sample input 'a'

    p <= reg_p;
    q <= reg_q;
end

endmodule