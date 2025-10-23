module edge_detect (
    input  wire clk,
    input  wire rst_n,   // active low synchronous reset
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync_0;
    reg a_sync_1;

    always @(posedge clk) begin
        if (!rst_n) begin
            a_sync_0 <= 1'b0;
            a_sync_1 <= 1'b0;
            rise     <= 1'b0;
            down     <= 1'b0;
        end else begin
            // Synchronize input 'a' with two flip-flops
            a_sync_0 <= a;
            a_sync_1 <= a_sync_0;

            // Detect edges by comparing synchronized signals
            rise <= (~a_sync_1) & a_sync_0;  // Rising edge: 0->1 transition
            down <= a_sync_1 & (~a_sync_0);  // Falling edge: 1->0 transition
        end
    end

endmodule