module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

reg a_d; // delayed version of input a

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_d <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Detect rising edge: previous a = 0, current a = 1
        rise <= (~a_d) & a;
        // Detect falling edge: previous a = 1, current a = 0
        down <= a_d & (~a);
        // Store current a for next comparison
        a_d <= a;
    end
end

endmodule