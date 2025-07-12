module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_sync0, a_sync1;

    // Enable first stage only when input 'a' differs from last sample to reduce toggling
    wire a_change = (a != a_sync0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync0 <= 1'b0;
        else if (a_change)
            a_sync0 <= a;
    end

    // Second stage always clocks to safely synchronize
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync1 <= 1'b0;
        else
            a_sync1 <= a_sync0;
    end

    // Detect rising edge: previous 0, current 1
    assign rise = (~a_sync1) & a_sync0;

    // Detect falling edge: previous 1, current 0
    assign down = a_sync1 & (~a_sync0);

endmodule