module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire clk_en = load | (ena == 2'b01) | (ena == 2'b10);

    always @(posedge clk) begin
        if (clk_en) begin
            if (load) begin
                q <= data;
            end else begin
                if (ena == 2'b01) begin
                    // Rotate right by one bit
                    q <= {q[0], q[99:1]};
                end else if (ena == 2'b10) begin
                    // Rotate left by one bit
                    q <= {q[98:0], q[99]};
                end
                // else no rotation, q keeps same value (no clock enable disables update)
            end
        end
        // else retain q unchanged by clock gating
    end

endmodule