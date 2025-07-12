module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    wire clk_enable;
    reg [7:0] prev_in_gated;
    
    // Enable clock when input changes
    assign clk_enable = (in != prev_in);
    
    // Clock-gated register update
    always @(posedge clk) begin
        if (clk_enable) begin
            prev_in <= in;
        end
    end
    
    // Edge detection remains the same but with gated registers
    assign pedge = ~prev_in & in;

endmodule