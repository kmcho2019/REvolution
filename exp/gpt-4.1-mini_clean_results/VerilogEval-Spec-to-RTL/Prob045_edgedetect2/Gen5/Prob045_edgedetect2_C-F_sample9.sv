module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // Register the previous input on the rising clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Output is combinational XOR of current and previous inputs,
    // representing edges detected on the previous cycle (output is high one cycle after transition)
    assign anyedge = in ^ prev_in;

endmodule