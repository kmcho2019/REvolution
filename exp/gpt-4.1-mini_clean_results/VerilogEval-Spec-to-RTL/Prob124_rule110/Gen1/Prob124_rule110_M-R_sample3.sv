module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            // Extract neighbors with zero padding at boundaries
            wire left  = (i < 511) ? q[i+1] : 1'b0;
            wire center = q[i];
            wire right = (i > 0) ? q[i-1] : 1'b0;

            wire [2:0] neighborhood = {left, center, right};

            // Rule 110 truth table encoded as a 8-bit value:
            // Index = neighborhood pattern; bit value = next state
            // bit order: 7-> neighborhood 111, down to 0->000
            // Rule110 bits: 8'b01101110 
            // 111=0,110=1,101=1,100=0,011=1,010=1,001=1,000=0
            assign next_q[i] = 
                (neighborhood == 3'b111) ? 1'b0 :
                (neighborhood == 3'b110) ? 1'b1 :
                (neighborhood == 3'b101) ? 1'b1 :
                (neighborhood == 3'b100) ? 1'b0 :
                (neighborhood == 3'b011) ? 1'b1 :
                (neighborhood == 3'b010) ? 1'b1 :
                (neighborhood == 3'b001) ? 1'b1 :
                /* neighborhood == 3'b000 */ 1'b0;
        end
    endgenerate

    always @(posedge clk) begin
        if (load) 
            q <= data;
        else 
            q <= next_q;
    end

endmodule