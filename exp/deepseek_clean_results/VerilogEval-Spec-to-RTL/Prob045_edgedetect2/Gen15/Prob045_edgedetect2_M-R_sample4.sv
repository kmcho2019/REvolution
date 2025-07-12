module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores input from previous cycle

    // Combinational logic: detect edges using XOR
    assign anyedge = in ^ prev_in;

    // Sequential logic: store current input for next cycle
    always @(posedge clk) begin
        prev_in <= in;
    end

endmodule