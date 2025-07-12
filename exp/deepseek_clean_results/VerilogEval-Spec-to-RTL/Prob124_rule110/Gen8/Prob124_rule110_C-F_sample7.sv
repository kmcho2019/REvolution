module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extended register for boundary handling (q[-1]=0, q[512]=0)
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Combinational next state calculation
    wire [511:0] next_q;

    // Generate next state for each bit
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Get neighbors from extended register
            wire left = extended_q[i+2];
            wire center = extended_q[i+1];
            wire right = extended_q[i];
            
            // Optimized Rule 110 logic:
            // When left=0: center OR right
            // When left=1: center XOR right, except when all three are 1
            assign next_q[i] = left ? 
                              ((center & right) ? 1'b0 : center ^ right) :
                              (center | right);
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule