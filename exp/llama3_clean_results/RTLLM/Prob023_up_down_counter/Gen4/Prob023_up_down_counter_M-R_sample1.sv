module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    case ({reset, up_down})
        2'b10: count <= 16'd0; // Reset takes priority
        2'b01: count <= count - 1; // Decrement
        2'b11: count <= count + 1; // Increment
        default: count <= count; // No change if reset is low and up_down is high (this should not occur due to the priority of reset)
    endcase
end

endmodule