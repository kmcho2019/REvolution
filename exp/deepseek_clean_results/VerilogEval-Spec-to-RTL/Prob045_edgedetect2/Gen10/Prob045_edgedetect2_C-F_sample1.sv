module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // First store the current input for next cycle comparison
        prev_in <= in;
        
        // Then detect edges by comparing with previous input
        anyedge <= in ^ prev_in;
    end

endmodule