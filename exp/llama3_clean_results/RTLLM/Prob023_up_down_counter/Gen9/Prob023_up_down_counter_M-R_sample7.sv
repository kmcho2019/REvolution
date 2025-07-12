module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @ (posedge clk) begin
    case ({reset, up_down})
        2'b10: count <= 16'd0; // Reset is high, reset counter
        2'b01: count <= (count == 16'd0) ? 16'd65535 : count - 1; // Decrement
        2'b11: count <= (count == 16'd65535) ? 16'd0 : count + 1; // Increment
        default: count <= count; // Do nothing when reset is low and up_down is low
    endcase
end

endmodule