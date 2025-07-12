module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync_0;
    reg a_sync_1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync_0 <= 1'b0;
            a_sync_1 <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Two-stage synchronizer for 'a'
            a_sync_0 <= a;
            a_sync_1 <= a_sync_0;

            // Detect rising edge
            if (~a_sync_1 & a_sync_0)
                rise <= 1'b1;
            else
                rise <= 1'b0;

            // Detect falling edge
            if (a_sync_1 & ~a_sync_0)
                down <= 1'b1;
            else
                down <= 1'b0;
        end
    end

endmodule