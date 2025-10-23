module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 32'b0;
        end
        else begin
            // Each bit in state serves dual purpose:
            // 1. Remembers if input was high last cycle (for edge detection)
            // 2. Maintains capture status (sticky 1)
            state <= (state | in) & ~(in & ~state);
        end
    end

    assign out = state;

endmodule