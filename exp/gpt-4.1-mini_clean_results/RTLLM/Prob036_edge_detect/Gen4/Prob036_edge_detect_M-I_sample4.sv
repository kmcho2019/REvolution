module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_dly <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Store previous value of 'a' for edge detection
            a_dly <= a;

            // Detect edges comparing current 'a' and previous 'a_dly'
            // rise is high when transition 0->1 detected at previous clock
            // down is high when transition 1->0 detected at previous clock
            rise <= (~a_dly) & a;
            down <= a_dly & (~a);
        end
    end

endmodule