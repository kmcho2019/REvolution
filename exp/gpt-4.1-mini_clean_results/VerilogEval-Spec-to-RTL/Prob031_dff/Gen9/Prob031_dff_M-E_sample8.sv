module TopModule (
    input clk,      // Clock input
    input d,        // Data input
    output reg q    // Registered output
);
    // Internal wire to hold the input value combinationally
    wire d_internal;
    
    assign d_internal = d;  // Buffer input to internal wire
    
    // On positive clock edge, capture d_internal into q
    always @(posedge clk) begin
        q <= d_internal;
    end
endmodule