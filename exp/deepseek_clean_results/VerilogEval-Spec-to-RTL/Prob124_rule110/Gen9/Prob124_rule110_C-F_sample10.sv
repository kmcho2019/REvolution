module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    genvar i;

    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Get neighbors with boundary conditions
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            
            // Optimized Rule 110 logic:
            assign next_q[i] = (left & center & right) ? 1'b0 :
                              left ? (center ^ right) :
                              (center | right);
        end
    endgenerate

    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule