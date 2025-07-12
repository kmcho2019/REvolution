module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync;
    reg a_prev;
    wire rise_edge, down_edge;
    wire update_en;

    // Synchronize input 'a' (assuming 'a' may be asynchronous or slow)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 1'b0;
        else
            a_sync <= a;
    end

    // Register previous synchronized value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a_sync;
    end

    // Combinational edge detection
    assign rise_edge = (~a_prev) & a_sync;
    assign down_edge = a_prev & (~a_sync);
    assign update_en = rise_edge | down_edge;

    // Register outputs: pulse high for one cycle after edge detection,
    // update only when edge occurs to reduce toggling and power
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else if (update_en) begin
            rise <= rise_edge;
            down <= down_edge;
        end else begin
            rise <= 1'b0;
            down <= 1'b0;
        end
    end

endmodule