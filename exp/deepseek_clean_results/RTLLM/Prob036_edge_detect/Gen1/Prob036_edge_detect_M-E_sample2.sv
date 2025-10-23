module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg [1:0] a_sync;  // Two-stage synchronizer

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_sync <= 2'b00;
        rise <= 1'b0;
        down <= 1'b0;
    end
    else begin
        // Synchronizer chain
        a_sync <= {a_sync[0], a};

        // Edge detection using the two most recent synchronized values
        rise <= (a_sync == 2'b01);  // 0->1 transition
        down <= (a_sync == 2'b10);   // 1->0 transition
    end
end

endmodule