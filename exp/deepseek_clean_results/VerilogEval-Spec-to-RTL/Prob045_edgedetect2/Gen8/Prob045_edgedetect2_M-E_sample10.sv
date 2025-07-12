module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in [1:0];  // 2-deep history buffer

    always @(posedge clk) begin
        // Shift register update
        prev_in[1] <= prev_in[0];
        prev_in[0] <= in;
        
        // Edge detection (current different from either previous value)
        anyedge <= (in ^ prev_in[0]) | (in ^ prev_in[1]);
    end

endmodule