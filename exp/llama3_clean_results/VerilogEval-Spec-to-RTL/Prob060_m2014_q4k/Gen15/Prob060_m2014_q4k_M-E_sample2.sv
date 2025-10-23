// 1-bit D Flip-Flop with Multiplexer and Clock Gating
module DFF_MUX(
    input clk,
    input clk_en,
    input resetn,
    input sel,
    input d0,
    input d1,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else if (clk_en) begin
        q <= sel ? d1 : d0;
    end
end

endmodule

// TopModule with Pipelined Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;
reg [3:0] clk_en;

// Reset counter to synchronize reset operation
reg [1:0] reset_cnt;
always @(posedge clk) begin
    if (!resetn) begin
        reset_cnt <= 2'b0;
    end else begin
        reset_cnt <= reset_cnt + 1'b1;
    end
end

// Clock-gating logic
always @(*) begin
    clk_en[0] = 1'b1; // Always enable first stage
    clk_en[1] = q[0]; // Enable second stage if first stage has data
    clk_en[2] = q[1]; // Enable third stage if second stage has data
    clk_en[3] = q[2]; // Enable fourth stage if third stage has data
end

// Instantiate DFF_MUX modules
DFF_MUX dff0(clk, clk_en[0], resetn, 1'b0, in, 1'b0, q[0]);
DFF_MUX dff1(clk, clk_en[1], resetn, 1'b1, q[0], 1'b0, q[1]);
DFF_MUX dff2(clk, clk_en[2], resetn, 1'b1, q[1], 1'b0, q[2]);
DFF_MUX dff3(clk, clk_en[3], resetn, 1'b1, q[2], 1'b0, q[3]);

// Assign output directly from the last bit of the pipeline
assign out = q[3];

endmodule