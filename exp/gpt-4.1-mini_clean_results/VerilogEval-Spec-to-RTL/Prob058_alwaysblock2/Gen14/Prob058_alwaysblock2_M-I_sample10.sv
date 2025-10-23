module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment XOR
    assign out_assign = a ^ b;

    // Combinational always block
    always @* begin
        out_always_comb = a ^ b;
    end

    // Register to hold previous XOR value for change detection
    reg prev_xor;

    wire xor_val = a ^ b;

    // Sequential always block with enable logic to update only when XOR changes
    always @(posedge clk) begin
        if (xor_val != prev_xor) begin
            out_always_ff <= xor_val;
            prev_xor <= xor_val;
        end
        else begin
            // hold previous values to avoid toggling
            out_always_ff <= out_always_ff;
            prev_xor <= prev_xor;
        end
    end

endmodule