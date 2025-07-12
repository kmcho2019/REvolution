module TopModule #(
    parameter DELAY_CYCLES = 1  // Configurable delay length
)(
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Shared XOR result
    wire xor_result = a ^ b;

    // Continuous assignment (direct connection)
    assign out_assign = xor_result;

    // Combinational always block
    always_comb begin
        out_always_comb = xor_result;
    end

    // Shift register for delayed output
    reg [DELAY_CYCLES-1:0] delay_line;

    always @(posedge clk) begin
        if (DELAY_CYCLES > 0) begin
            // Shift new value in
            delay_line <= {delay_line[DELAY_CYCLES-2:0], xor_result};
            out_always_ff <= delay_line[DELAY_CYCLES-1];
        end else begin
            // Bypass delay if parameter is 0
            out_always_ff <= xor_result;
        end
    end

endmodule