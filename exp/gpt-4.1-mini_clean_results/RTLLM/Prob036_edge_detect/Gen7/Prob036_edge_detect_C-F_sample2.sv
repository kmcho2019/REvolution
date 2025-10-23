module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync;
    reg a_prev;
    wire rise_edge;
    wire fall_edge;

    // Synchronize input 'a' with double flip-flop synchronizer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync <= 1'b0;
            a_prev <= 1'b0;
        end else begin
            a_sync <= a;
            a_prev <= a_sync;
        end
    end

    // Detect edges combinationally from synchronized signals
    assign rise_edge = (~a_prev) & a_sync;
    assign fall_edge = a_prev & (~a_sync);

    // Register outputs rise and down to pulse for one clock cycle after edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_edge;
            down <= fall_edge;
        end
    end

endmodule