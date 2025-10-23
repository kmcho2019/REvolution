module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg prev_a;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 0;
        rise <= 0;
        down <= 0;
    end else begin
        prev_a <= a;
        rise <= a && !prev_a; // Rising edge detection
        down <= !a && prev_a; // Falling edge detection
    end
end

endmodule