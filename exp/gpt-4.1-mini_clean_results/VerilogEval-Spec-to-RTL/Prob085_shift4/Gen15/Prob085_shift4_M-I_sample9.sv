module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Clock gating enable: only clock when load or ena is active
wire clk_en = load | ena;
reg gated_clk;

// Simple clock gating register (could be replaced with dedicated clock gating cell in ASIC flows)
always @(posedge clk or posedge areset) begin
    if (areset)
        gated_clk <= 1'b0;
    else
        gated_clk <= clk_en;
end

reg [3:0] q_next;

always @(*) begin
    if (load) begin
        q_next = data;
    end else if (ena) begin
        q_next = {1'b0, q[3:1]};
    end else begin
        q_next = q;
    end
end

// Use gated_clk for clocking flip-flops to reduce unnecessary toggling
always @(posedge gated_clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000;
    end else begin
        q <= q_next;
    end
end

endmodule