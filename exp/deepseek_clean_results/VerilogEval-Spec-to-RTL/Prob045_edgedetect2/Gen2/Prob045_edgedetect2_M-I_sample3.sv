module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Store previous input
        prev_in <= in;
        
        // Edge detection: XOR current with previous input
        anyedge <= in ^ prev_in;
    end

endmodule