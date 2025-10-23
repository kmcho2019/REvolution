module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] in_changed;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_in <= 8'b0;
            pedge <= 8'b0;
        end
        else begin
            in_changed <= in ^ prev_in;  // Detect which bits changed
            prev_in <= (in_changed != 8'b0) ? in : prev_in;  // Only update if changes occurred
            pedge <= in & ~prev_in;
        end
    end

endmodule