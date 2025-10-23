module XorGate (
    input wire x,
    input wire y,
    output wire z
);
    // Structural XOR primitive gate
    xor (z, x, y);
endmodule

module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Wire driven by structural XOR gate
    wire xor_structural;

    XorGate xor_inst (
        .x(a),
        .y(b),
        .z(xor_structural)
    );

    // Assign output driven by structural XOR gate output
    assign out_assign = xor_structural;

    // Combinational always block uses shared structural XOR output
    always @(*) begin
        out_always_comb = xor_structural;
    end

    // Sequential always block registers XOR on posedge clk with nonblocking assignment
    always @(posedge clk) begin
        out_always_ff <= a ^ b; // direct behavioral expression
    end

endmodule