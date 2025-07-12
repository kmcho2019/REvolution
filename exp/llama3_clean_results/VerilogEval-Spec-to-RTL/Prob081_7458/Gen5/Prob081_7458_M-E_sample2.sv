// Parameterizable AND/OR gate module
module ConfigGate(
    input  enable_and,  // 1 for AND, 0 for OR
    input  [3:0] inputs,  // 4 input signals
    output reg y
);
    always @(*) begin
        if (enable_and) begin
            // AND operation
            y = inputs[0] & inputs[1] & inputs[2] & inputs[3];
        end else begin
            // OR operation
            y = inputs[0] | inputs[1] | inputs[2] | inputs[3];
        end
    end
endmodule

// TopModule using ConfigGate
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);
    wire and1_out, and2_out, and3_out, and4_out;

    // 3-input AND gates
    ConfigGate and1(1'b1, {p1a, p1b, p1c, 1'b1}, and1_out);
    ConfigGate and2(1'b1, {p1d, p1e, p1f, 1'b1}, and2_out);

    // 2-input AND gates
    ConfigGate and3(1'b1, {p2a, p2b, 1'b0, 1'b0}, and3_out);
    ConfigGate and4(1'b1, {p2c, p2d, 1'b0, 1'b0}, and4_out);

    // OR gates
    ConfigGate or1(1'b0, {and1_out, and2_out, 1'b0, 1'b0}, p1y);
    ConfigGate or2(1'b0, {and3_out, and4_out, 1'b0, 1'b0}, p2y);
endmodule