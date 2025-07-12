module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;

    // Register input signal 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Combinational edge detection signals
    wire rise_w =  a & ~a_d;
    wire down_w = ~a &  a_d;

    // Register outputs synchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_w;
            down <= down_w;
        end
    end

endmodule