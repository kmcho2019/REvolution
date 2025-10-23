module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Combinational logic for next state computation
    genvar i;
    generate
        for (i = 0; i < 512; i = i+1) begin : rule110
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire center = q[i];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            
            assign next_q[i] = 
                ({left, center, right} == 3'b111) ? 1'b0 :
                ({left, center, right} == 3'b110) ? 1'b1 :
                ({left, center, right} == 3'b101) ? 1'b1 :
                ({left, center, right} == 3'b100) ? 1'b0 :
                ({left, center, right} == 3'b011) ? 1'b1 :
                ({left, center, right} == 3'b010) ? 1'b1 :
                ({left, center, right} == 3'b001) ? 1'b1 :
                /* default */ 1'b0;
        end
    endgenerate

    // Sequential logic for state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule