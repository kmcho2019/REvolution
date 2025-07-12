module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Combined sequential and combinational logic
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        if (q != 4'b1111) begin  // Clock gating condition
            q <= q + 1;
        end
        else begin
            q <= 4'b0000;  // Roll over to 0
        end
    end
end

endmodule