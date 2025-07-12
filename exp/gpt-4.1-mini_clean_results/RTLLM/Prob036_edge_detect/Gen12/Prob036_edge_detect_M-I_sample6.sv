module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;  // delayed version of input a

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_d) & a;  // rising edge detection
            down <= a_d & (~a);  // falling edge detection
            a_d <= a;
        end
    end

endmodule