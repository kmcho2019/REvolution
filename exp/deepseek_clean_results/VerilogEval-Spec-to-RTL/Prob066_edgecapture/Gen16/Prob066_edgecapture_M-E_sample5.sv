module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Generate 32 parallel bit detectors
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : bit_detectors
            reg prev_bit;
            reg out_bit;
            
            always @(posedge clk) begin
                if (reset) begin
                    prev_bit <= 1'b0;
                    out_bit <= 1'b0;
                end else begin
                    // Detect falling edge and set sticky output
                    if (prev_bit && !in[i]) begin
                        out_bit <= 1'b1;
                    end
                    prev_bit <= in[i];
                end
            end
            
            assign out[i] = out_bit;
        end
    endgenerate

endmodule