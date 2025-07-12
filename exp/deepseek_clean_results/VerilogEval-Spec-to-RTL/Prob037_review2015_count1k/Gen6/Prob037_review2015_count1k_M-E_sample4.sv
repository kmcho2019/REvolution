module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire [9:0] next_lfsr;
wire terminal_count;

// LFSR feedback polynomial for 10 bits: x^10 + x^7 + 1
assign next_lfsr = {q[8:0], q[9] ^ q[6]};

// Terminal count detection
assign terminal_count = (q == 10'd999);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0;
    end
    else begin
        if (terminal_count) begin
            q <= 10'd0;
        end
        else begin
            // Force sequential counting by adding 1 to the LFSR value
            q <= next_lfsr + 1'b1;
        end
    end
end

endmodule