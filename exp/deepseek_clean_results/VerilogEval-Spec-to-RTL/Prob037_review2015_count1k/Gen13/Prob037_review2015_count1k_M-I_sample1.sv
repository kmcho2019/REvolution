module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg terminal_count;
wire [9:0] next_q = reset ? 10'b0 : 
                   (terminal_count ? 10'b0 : q + 1'b1);

// Clock gating control
wire count_enable = ~terminal_count;
reg gated_clk;

always @(posedge clk) begin
    gated_clk <= count_enable;
end

// Two-stage terminal count detection
wire [4:0] upper_bits = q[9:5];
wire [4:0] lower_bits = q[4:0];
wire upper_match = (upper_bits == 5'b01111); // 15 (upper part of 999)
wire lower_match = (lower_bits == 5'b11001); // 25 (lower part of 999)

always @(posedge clk) begin
    terminal_count <= upper_match & lower_match;
    if (gated_clk || reset) begin
        q <= next_q;
    end
end

endmodule