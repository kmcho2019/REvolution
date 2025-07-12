module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync_0, a_sync_1;

    // Synchronize and register input signal 'a' twice to avoid metastability
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync_0 <= 1'b0;
            a_sync_1 <= 1'b0;
        end else begin
            a_sync_0 <= a;
            a_sync_1 <= a_sync_0;
        end
    end

    // Detect edges by comparing synchronized samples
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_sync_1) & a_sync_0;  // 0 -> 1 transition
            down <= a_sync_1 & (~a_sync_0);  // 1 -> 0 transition
        end
    end

endmodule