module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;

    // Register the input signal 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 1'b0;
        end else begin
            a_reg <= a;
        end
    end

    // Combinational edge detection signals
    wire rise_detect = (~a_reg) & a;  // 0 -> 1 transition
    wire down_detect = a_reg & (~a);  // 1 -> 0 transition

    // Register outputs capturing the edge detection signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_detect;
            down <= down_detect;
        end
    end

endmodule