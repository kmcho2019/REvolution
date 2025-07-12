module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;
reg toggle;

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
        toggle <= 1'b0;
    end else begin
        if (up_down) begin
            toggle <= ~toggle;
        end
        if (toggle) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule