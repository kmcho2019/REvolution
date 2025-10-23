module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= up_down ? (count + 1) : (count - 1);
        if (count == 16'd0 && ~up_down) begin
            count <= 16'd65535;
        end else if (count == 16'd65535 && up_down) begin
            count <= 16'd0;
        end
    end
end

endmodule