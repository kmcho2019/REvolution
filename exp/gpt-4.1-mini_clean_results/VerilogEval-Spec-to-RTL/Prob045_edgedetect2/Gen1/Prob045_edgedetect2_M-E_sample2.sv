module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Compare current input with previous input to detect edges from last cycle
        anyedge <= prev_in ^ in;
        // Update prev_in for next cycle's comparison
        prev_in <= in;
    end

endmodule