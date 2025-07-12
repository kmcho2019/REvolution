module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    // Synchronized reset chain
    reg [7:0] reset_chain = 8'b0;
    
    always @(posedge clk) begin
        reset_chain <= {reset_chain[6:0], reset};
    end

    // Individual DFFs with staggered reset
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            reg q_bit;
            
            always @(posedge clk) begin
                if (reset_chain[i])
                    q_bit <= 1'b0;
                else
                    q_bit <= d[i];
            end
            
            assign q[i] = q_bit;
        end
    endgenerate
endmodule