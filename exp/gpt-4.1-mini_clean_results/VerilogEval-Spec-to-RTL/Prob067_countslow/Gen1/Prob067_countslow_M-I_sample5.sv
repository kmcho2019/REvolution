module TopModule(
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire [4:0] q_plus_one = {1'b0, q} + 5'd1; // 5-bit to catch carry
wire carry_out = q_plus_one[4];

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else if (slowena) begin
        if (carry_out)  // q was 9, incrementing leads to 10, wrap to 0
            q <= 4'd0;
        else
            q <= q + 4'd1;
    end
end

endmodule