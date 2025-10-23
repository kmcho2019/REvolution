module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : bit_edge_detectors
            reg prev_val;
            reg captured;
            
            always @(posedge clk) begin
                if (reset) begin
                    prev_val <= 1'b0;
                    captured <= 1'b0;
                end
                else begin
                    prev_val <= in[i];
                    if (prev_val && !in[i]) begin
                        captured <= 1'b1;
                    end
                end
            end
            
            assign out[i] = captured;
        end
    endgenerate

endmodule