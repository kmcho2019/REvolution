module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

reg a_d;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_d  <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Detect rising edge: a_d == 0 and a == 1
        rise <= (~a_d) & a;
        // Detect falling edge: a_d == 1 and a == 0
        down <= a_d & (~a);
        a_d <= a;
    end
end

endmodule