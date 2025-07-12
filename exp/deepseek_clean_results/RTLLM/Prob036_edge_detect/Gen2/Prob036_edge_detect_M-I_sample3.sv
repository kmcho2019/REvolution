module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_prev;  // Stores the previous value of 'a'
    wire clk_en; // Clock enable signal

    // Clock gating: only enable clock when 'a' changes
    assign clk_en = (a != a_prev) | ~rst_n;

    // Gated clock
    wire gated_clk;
    assign gated_clk = clk & clk_en;

    // Sequential part: store previous value with gated clock
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end
        else begin
            a_prev <= a;
        end
    end

    // Combinational part: edge detection
    assign rise = a & ~a_prev;  // Rising edge detection
    assign down = ~a & a_prev;  // Falling edge detection

endmodule