module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_prev;  // Stores the previous value of 'a'

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end
        else begin
            a_prev <= a;
            rise   <= a & ~a_prev;  // Rising edge detection
            down   <= ~a & a_prev;  // Falling edge detection
        end
    end

endmodule