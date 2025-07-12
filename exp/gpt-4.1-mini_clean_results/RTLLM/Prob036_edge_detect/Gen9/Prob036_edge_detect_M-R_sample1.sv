module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_prev;
    wire rise_w, down_w;

    // Register previous state of 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Detect edges combinationally based on current and previous 'a'
    assign rise_w = (~a_prev) & a;
    assign down_w = a_prev & (~a);

    // Register rise and down outputs so they assert one clock cycle after edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_w;
            down <= down_w;
        end
    end

endmodule