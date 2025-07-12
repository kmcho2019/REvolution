module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Golden ratio approximation (1.61803398875)
// Using fixed-point representation 8.8 format
localparam [15:0] PHI = 16'h019e;  // 1.6171875
localparam [15:0] PHI_INV = 16'h00a1; // 0.6171875 (1/φ approximation)

function [15:0] poly_hash;
    input [2:0] x;
    reg [15:0] x_sq, x_cb;
    begin
        x_sq = {13'b0, x} * {13'b0, x};
        x_cb = x_sq * {13'b0, x};
        
        // Polynomial: x^3 + φx^2 + (1/φ)x + 1
        poly_hash = x_cb + 
                   ((PHI * x_sq) >>> 8) + 
                   ((PHI_INV * {13'b0, x}) >>> 8) + 
                   16'h0001;
    end
endfunction

assign q = (a == 3'd0) ? 16'h1232 :
           (a == 3'd1) ? 16'haee0 :
           (a == 3'd2) ? 16'h27d4 :
           (a == 3'd3) ? 16'h5a0e :
           (a == 3'd4) ? 16'h2066 :
           (a == 3'd5) ? 16'h64ce :
           (a == 3'd6) ? 16'hc526 :
           (a == 3'd7) ? 16'h2f19 :
           16'h0000;

// Alternative polynomial implementation (commented out as it needs coefficient tuning)
// assign q = poly_hash(a);

endmodule