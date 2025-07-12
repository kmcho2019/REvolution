module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // Double synchronizer for input 'a'
    reg a_sync_0, a_sync_1;
    // Previous stable sample of 'a_sync_1'
    reg a_sync_1_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync_0   <= 1'b0;
            a_sync_1   <= 1'b0;
            a_sync_1_d <= 1'b0;
            rise       <= 1'b0;
            down       <= 1'b0;
        end else begin
            // Synchronize input 'a' into clk domain
            a_sync_0 <= a;
            a_sync_1 <= a_sync_0;

            // Save previous stable value
            a_sync_1_d <= a_sync_1;

            // Detect edges: rise if 0->1, down if 1->0
            rise <=  a_sync_1 & ~a_sync_1_d;
            down <= ~a_sync_1 &  a_sync_1_d;
        end
    end

endmodule