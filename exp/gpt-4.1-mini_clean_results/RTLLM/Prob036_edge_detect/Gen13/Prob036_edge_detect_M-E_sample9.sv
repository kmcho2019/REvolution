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
            a_sync_0 <= a;
            a_sync_1 <= a_sync_0;

            rise <= (~a_sync_1) & a_sync_0;   // rising edge detected at current clock
            down <= a_sync_1 & (~a_sync_0);  // falling edge detected at current clock
        end
    end

endmodule