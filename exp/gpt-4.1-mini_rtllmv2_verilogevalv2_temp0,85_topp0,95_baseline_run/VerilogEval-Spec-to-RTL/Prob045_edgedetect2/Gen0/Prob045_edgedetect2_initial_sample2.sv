module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in; // XOR detects changes between current and previous inputs
        prev_in <= in;           // store current input for next comparison
    end

endmodule