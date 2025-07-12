module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_sync;

    // Synchronize input 'a' to clk domain with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync <= 2'b00;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            a_sync <= {a_sync[0], a};

            // Detect rising edge: previous 0, current 1
            rise <= (~a_sync[1]) & a_sync[0];

            // Detect falling edge: previous 1, current 0
            down <= a_sync[1] & (~a_sync[0]);
        end
    end

endmodule