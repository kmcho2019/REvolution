module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment implementation (direct wire connection)
    assign out_assign = a ^ b;

    // Combinational always block implementation (explicit always @*)
    reg comb_result;
    assign out_always_comb = comb_result;
    always @(*) begin
        comb_result = a ^ b;
    end

    // Sequential implementation with clock gating for power optimization
    // synthesis translate_off
    initial out_always_ff = 1'b0;
    // synthesis translate_on

    always @(posedge clk) begin
        if (a !== b) begin  // Only update when inputs change (implicit clock gating)
            out_always_ff <= a ^ b;
        end
    end

endmodule