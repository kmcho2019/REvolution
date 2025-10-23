module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire clk_enable = (in != prev_in);  // Clock gating control
    
    always @(posedge clk) begin
        if (clk_enable) begin
            prev_in <= in;
        end
        pedge <= in & ~prev_in;
    end

endmodule