module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;

always @ (*) begin
    case ({reset, up_down})
        2'b10: next_count = 16'd0;
        2'b01: next_count = (count == 16'd0) ? 16'd65535 : count - 1;
        2'b11: next_count = (count == 16'd65535) ? 16'd0 : count + 1;
        default: next_count = count;
    endcase
end

always @ (posedge clk) begin
    count <= next_count;
end

endmodule