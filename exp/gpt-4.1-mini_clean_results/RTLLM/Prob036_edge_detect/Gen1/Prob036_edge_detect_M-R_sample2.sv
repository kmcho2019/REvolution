module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg [1:0] a_sync;

    // Synchronize input 'a' to clk domain using a 2-flip-flop synchronizer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 2'b00;
        else
            a_sync <= {a_sync[0], a};
    end

    // Edge detection: rising edge if previous is 0 and current is 1
    assign rise = (~a_sync[1]) & a_sync[0];

    // Edge detection: falling edge if previous is 1 and current is 0
    assign down = a_sync[1] & (~a_sync[0]);

endmodule