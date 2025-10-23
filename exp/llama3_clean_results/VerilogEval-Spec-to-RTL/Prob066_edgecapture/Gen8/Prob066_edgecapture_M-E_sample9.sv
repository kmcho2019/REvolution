module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

// Define a module for each bit of the input vector
module bit_module(
    input clk,
    input reset,
    input in,
    output out
);
    reg prev_in;
    reg out_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 1'b0;
            out_reg <= 1'b0;
        end else begin
            // Update prev_in for the next cycle
            prev_in <= in;
            
            // Detect transition and update out_reg
            if (~in & prev_in) begin
                out_reg <= 1'b1;
            end
        end
    end

    assign out = out_reg;
endmodule

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