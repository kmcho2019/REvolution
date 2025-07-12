module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg enable;
reg Q0_inverted;

// Clock gating control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        enable <= 1'b1;
    end else begin
        // Freeze counter when pattern completes (optional)
        enable <= ~(Q == 64'hFFFFFFFFFFFFFFFF || Q == 64'h0);
    end
end

// First pipeline stage: Invert LSB
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q0_inverted <= 1'b0;
    end else if (enable) begin
        Q0_inverted <= ~Q[0];
    end
end

// Second pipeline stage: Shift operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else if (enable) begin
        Q <= {Q0_inverted, Q[63:1]};
    end
end

endmodule