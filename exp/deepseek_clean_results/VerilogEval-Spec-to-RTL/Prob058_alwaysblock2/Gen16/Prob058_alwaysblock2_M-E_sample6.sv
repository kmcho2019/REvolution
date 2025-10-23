module TopModule #(
    parameter USE_RESET = 0,       // Enable/disable reset for sequential output
    parameter REG_DELAY = 1        // Number of clock cycles delay for registered output
)(
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Shared XOR computation
    wire xor_result = a ^ b;

    // Direct assignment output
    assign out_assign = xor_result;

    // Combinational always block output
    assign out_always_comb = xor_result;

    // Sequential output with configurable delay
    generate
        if (USE_RESET) begin
            // With reset capability
            always @(posedge clk) begin
                if (REG_DELAY == 1)
                    out_always_ff <= xor_result;
                else begin
                    // Pipeline implementation for multi-cycle delay
                    reg [REG_DELAY-2:0] pipe;
                    pipe <= {pipe[REG_DELAY-3:0], xor_result};
                    out_always_ff <= pipe[REG_DELAY-2];
                end
            end
        end else begin
            // Without reset
            always @(posedge clk) begin
                if (REG_DELAY == 1)
                    out_always_ff <= xor_result;
                else begin
                    // Pipeline implementation for multi-cycle delay
                    reg [REG_DELAY-2:0] pipe;
                    pipe <= {pipe[REG_DELAY-3:0], xor_result};
                    out_always_ff <= pipe[REG_DELAY-2];
                end
            end
        end
    endgenerate

endmodule