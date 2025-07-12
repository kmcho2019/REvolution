module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;  // Store current input for next cycle comparison
    end

    assign anyedge = in ^ prev_in;  // XOR detects any change (both rising and falling edges)

endmodule