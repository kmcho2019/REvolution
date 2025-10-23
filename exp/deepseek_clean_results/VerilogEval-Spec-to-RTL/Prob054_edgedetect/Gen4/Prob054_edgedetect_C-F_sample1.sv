module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge,
    input en // Optional enable signal for power optimization
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        if (en) begin
            prev_in <= in;  // Only update when enabled
            pedge <= in & ~prev_in;  // Detect 0->1 transitions
        end else begin
            prev_in <= prev_in;  // Hold previous values
            pedge <= 8'b0;       // Clear output when disabled
        end
    end

endmodule