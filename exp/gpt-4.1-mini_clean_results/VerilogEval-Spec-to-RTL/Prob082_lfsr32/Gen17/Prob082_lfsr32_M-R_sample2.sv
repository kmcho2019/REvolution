module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire [31:0] next_q;
    wire feedback = q[0];
    wire [31:0] tap_mask = 32'h80200003;

    assign next_q = (q >> 1) ^ (feedback ? tap_mask : 32'b0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule