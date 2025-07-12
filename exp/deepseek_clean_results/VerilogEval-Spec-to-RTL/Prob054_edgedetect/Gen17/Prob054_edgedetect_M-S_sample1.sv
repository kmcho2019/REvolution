module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        pedge <= in & ~prev_in;  // Detect 0->1 transitions
        prev_in <= in;           // Store current input for next cycle
    end

endmodule