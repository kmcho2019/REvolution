module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync;
    reg a_prev;

    // Synchronize input 'a' with single flip-flop synchronizer (assuming slow changes)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 1'b0;
        else
            a_sync <= a;
    end

    // Register previous synchronized 'a' value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a_sync;
    end

    // Detect edges and generate one-cycle pulse outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_prev) & a_sync;  // rising edge: prev=0, curr=1
            down <= a_prev & (~a_sync);  // falling edge: prev=1, curr=0
        end
    end

endmodule