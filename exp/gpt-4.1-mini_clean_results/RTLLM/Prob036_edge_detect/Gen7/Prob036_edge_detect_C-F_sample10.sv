module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_sync;
    reg       a_prev;

    // Synchronize input 'a' to clk domain (2-flip-flop synchronizer)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 2'b00;
        else
            a_sync <= {a_sync[0], a};
    end

    // Store previous synchronized 'a' for edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a_sync[0];
    end

    // Generate rise and down pulses, registered for exactly one clock cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_prev) & a_sync[0];
            down <= a_prev & (~a_sync[0]);
        end
    end

endmodule