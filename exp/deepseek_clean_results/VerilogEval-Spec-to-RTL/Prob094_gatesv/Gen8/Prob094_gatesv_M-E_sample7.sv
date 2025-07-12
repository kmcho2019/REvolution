module TopModule (
    input [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    wire [3:0] left_neighbor = {in[0], in[3:1]}; // Circular left shift for wrap-around
    
    always @(*) begin
        // out_both: current bit AND left neighbor (except MSB)
        out_both = in & {in[0], in[3:1]};
        out_both[3] = 1'b0; // Explicitly set unused bit
        
        // out_any: current bit OR right neighbor (except LSB)
        out_any = in | {in[2:0], in[3]};
        out_any[0] = 1'b0; // Explicitly set unused bit
        
        // out_different: XOR with left neighbor (wrap-around)
        out_different = in ^ left_neighbor;
    end

endmodule