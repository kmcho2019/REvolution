module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VALUE = 8'h34;
reg [7:0] d_prev;
wire enable = (d != d_prev); // Enable only when input changes

always @(negedge clk) begin
    d_prev <= d; // Store previous input value
    
    if (reset) begin
        q <= RESET_VALUE;
    end else if (enable) begin
        q <= d;
    end
    // Else maintain current value (implicit)
end

endmodule