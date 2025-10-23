module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync_0, a_sync_1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync_0 <= 1'b0;
            a_sync_1 <= 1'b0;
            rise     <= 1'b0;
            down     <= 1'b0;
        end else begin
            // Synchronize input 'a' to clk domain
            a_sync_0 <= a;
            a_sync_1 <= a_sync_0;

            // Detect rising edge: prev low, curr high
            if (~a_sync_1 & a_sync_0)
                rise <= 1'b1;
            else if (down)  // Clear rise on falling edge
                rise <= 1'b0;

            // Detect falling edge: prev high, curr low
            if (a_sync_1 & ~a_sync_0)
                down <= 1'b1;
            else if (rise)  // Clear down on rising edge
                down <= 1'b0;
        end
    end

endmodule