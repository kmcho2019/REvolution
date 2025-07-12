// Define the bit_module outside of the TopModule
module bit_module(
    input clk,
    input reset,
    input in,
    output reg out
);

    reg prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b0;
            prev_in <= 1'b0;
        end else begin
            if (prev_in && !in) begin
                out <= 1'b1;
            end
            prev_in <= in;
        end
    end

endmodule

// Define the TopModule
module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Instantiate the bit_module for each bit of the input vector
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            bit_module bit_module_inst (
                .clk(clk),
                .reset(reset),
                .in(in[i]),
                .out(out[i])
            );
        end
    endgenerate

endmodule