module TopModule (
    input        clk,
    input        reset,     // synchronous active-high reset
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 8'b0;
            anyedge <= 8'b0;
        end else begin
            // Edge detection: XOR current input with previous input
            anyedge <= in ^ prev_in;
            // Update previous input for next cycle comparison
            prev_in <= in;
        end
    end

endmodule