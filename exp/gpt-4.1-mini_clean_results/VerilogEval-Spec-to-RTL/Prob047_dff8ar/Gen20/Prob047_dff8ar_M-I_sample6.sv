module TopModule (
    input  wire        clk,
    input  wire        areset,     // Asynchronous active-high reset
    input  wire [7:0]  d,
    output reg  [7:0]  q
);
    // Asynchronous reset DFFs for 8-bit vector
    // Reset q to zero asynchronously when areset is asserted
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule