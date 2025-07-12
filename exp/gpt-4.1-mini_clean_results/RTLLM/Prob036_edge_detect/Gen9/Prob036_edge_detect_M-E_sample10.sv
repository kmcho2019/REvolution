module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly1, a_dly2;

    // Sample input 'a' on clock, with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_dly1 <= 1'b0;
            a_dly2 <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            a_dly1 <= a;
            a_dly2 <= a_dly1;

            // Detect edges by comparing two delayed samples
            rise <= (~a_dly2) & a_dly1;  // 0->1 transition
            down <= a_dly2 & (~a_dly1);  // 1->0 transition
        end
    end

endmodule