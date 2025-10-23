module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

parameter MAX_COUNT = 16'hFFFF;
parameter MIN_COUNT = 16'h0000;

// Clock gating control - only enable when count will change
wire count_enable = ~reset & ((up_down & (count != MAX_COUNT)) | (~up_down & (count != MIN_COUNT)));

always @(posedge clk) begin
    if (reset) begin
        count <= MIN_COUNT;
    end else if (count_enable) begin
        // Unified adder/subtractor with direction control
        count <= up_down ? count + 1'b1 : count - 1'b1;
        
        // Automatic wrap-around handled by overflow/underflow
        // No explicit comparison needed due to natural 16-bit behavior
    end
end

endmodule