module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Store previous input values
        prev_in <= in;
        
        // Detect edges by XORing current and previous values
        anyedge <= in ^ prev_in;
    end

endmodule