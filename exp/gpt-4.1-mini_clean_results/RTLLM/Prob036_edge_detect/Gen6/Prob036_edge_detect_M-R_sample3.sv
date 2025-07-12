module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_sync;
    reg a_prev;

    // Synchronize input 'a' (assuming it's relatively slow and synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync <= 1'b0;
            a_prev <= 1'b0;
        end else begin
            a_sync <= a;
            a_prev <= a_sync;
        end
    end

    // Detect rising edge: previous is 0, current is 1
    assign rise = (~a_prev) & a_sync;

    // Detect falling edge: previous is 1, current is 0
    assign down = a_prev & (~a_sync);

endmodule