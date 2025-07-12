module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] capture;

always @(posedge clk) begin
    if (reset) begin
        capture <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1 && in[i] == 0) begin
                capture[i] <= 1;
            end
        end
    end
    prev_in <= in;
end

always @(*) begin
    out = capture;
end

endmodule