module counter_12 (
    input wire rst_n,          // Active low reset (synchronous)
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// Next state logic
reg [3:0] next_out;

always @(*) begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end else if (valid_count) begin
        if (out == 4'b1011) begin  // Terminal count
            next_out = 4'b0000;
        end else begin
            next_out = out + 1'b1;
        end
    end else begin
        next_out = out;  // Hold current value
    end
end

// State register
always @(posedge clk) begin
    out <= next_out;
end

endmodule