module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg [3:0] next_q;
reg overflow;

// Clock gating logic
wire gated_clk = clk & slowena;

// Registered overflow detection
always @(posedge clk) begin
    if (reset) begin
        overflow <= 1'b0;
    end else begin
        overflow <= q[3] & q[0];
    end
end

// Conditional next state calculation
always @(*) begin
    if (slowena) begin
        next_q = overflow ? 4'b0000 : q + 1'b1;
    end
end

// Sequential logic with gated clock
always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        q <= next_q;
    end
end

endmodule