module TopModule #(
    parameter WIDTH = 100,            // Configurable vector width
    parameter REGISTER_OUTPUT = 0,    // Optionally register output
    parameter USE_ENABLE = 0          // Enable power saving mode
) (
    input  [WIDTH-1:0] in,            // Input vector
    input              clk,           // Clock (required if REGISTER_OUTPUT=1)
    input              enable,        // Enable signal (optional)
    output [WIDTH-1:0] out            // Reversed output
);

// Internal signal for combinational output
wire [WIDTH-1:0] reversed;

// Bit reversal logic
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
        assign reversed[i] = in[WIDTH-1 - i];
    end
endgenerate

// Optional output registration for timing improvement
generate
    if (REGISTER_OUTPUT) begin : reg_output
        reg [WIDTH-1:0] out_reg;
        always @(posedge clk) begin
            if (!USE_ENABLE || enable) begin
                out_reg <= reversed;
            end
        end
        assign out = out_reg;
    end else begin : comb_output
        if (USE_ENABLE) begin : with_enable
            assign out = enable ? reversed : {WIDTH{1'b0}};
        end else begin : no_enable
            assign out = reversed;
        end
    end
endgenerate

endmodule