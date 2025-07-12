module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output wire out_always_ff
);

    // Basic XOR submodule
    module xor_gate(input a, input b, output y);
        assign y = a ^ b;
    endmodule

    // Instantiate continuous assignment version
    xor_gate assign_xor(.a(a), .b(b), .y(out_assign));

    // Combinational always block version
    reg comb_result;
    always @(*) begin
        comb_result = a ^ b;
    end
    assign out_always_comb = comb_result;

    // Sequential version with clock gating
    reg ff_input_changed;
    reg last_a, last_b;
    reg sequential_result;

    always @(posedge clk) begin
        last_a <= a;
        last_b <= b;
        ff_input_changed <= (a != last_a) || (b != last_b);
    end

    always @(posedge clk) begin
        if (ff_input_changed) begin
            sequential_result <= a ^ b;
        end
    end
    assign out_always_ff = sequential_result;

endmodule