module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync0, a_sync1;

    // Two-stage synchronizer for input 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync0 <= 1'b0;
            a_sync1 <= 1'b0;
        end else begin
            a_sync0 <= a;
            a_sync1 <= a_sync0;
        end
    end

    // Edge detection logic with registered outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_sync1) & a_sync0;
            down <= a_sync1 & (~a_sync0);
        end
    end

endmodule