module up_down_counter (
    input  wire       clk,
    input  wire       reset,
    input  wire       up_down,
    output reg [15:0] count
);

    // Synchronize up_down to clk domain to avoid glitches
    reg up_down_sync_0, up_down_sync_1;
    always @(posedge clk) begin
        if (reset) begin
            up_down_sync_0 <= 1'b0;
            up_down_sync_1 <= 1'b0;
        end else begin
            up_down_sync_0 <= up_down;
            up_down_sync_1 <= up_down_sync_0;
        end
    end

    wire up_down_sync = up_down_sync_1;

    // Next count logic separated
    wire [15:0] count_next = up_down_sync ? (count + 16'd1) : (count - 16'd1);

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= count_next;
    end

endmodule