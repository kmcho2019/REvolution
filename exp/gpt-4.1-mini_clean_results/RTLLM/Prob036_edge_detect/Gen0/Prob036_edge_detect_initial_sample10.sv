module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;  // delayed version of a

    always @(posedge clk) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_d) & a;  // previous 0, current 1 => rising edge
            down <= a_d & (~a);  // previous 1, current 0 => falling edge
            a_d  <= a;           // update delayed signal
        end
    end

endmodule