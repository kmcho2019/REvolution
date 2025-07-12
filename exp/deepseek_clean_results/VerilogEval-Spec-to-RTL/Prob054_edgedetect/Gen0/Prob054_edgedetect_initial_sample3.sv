module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;  // Store previous input values
        pedge <= (in & ~prev_in);  // Detect 0->1 transitions
    end

endmodule