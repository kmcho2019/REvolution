module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;
    wire rise_detect;
    wire down_detect;

    // Register previous state of 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_dly <= 1'b0;
        else
            a_dly <= a;
    end

    // Combinational logic for edge detection
    assign rise_detect = (~a_dly) & a;   // rising edge condition
    assign down_detect = a_dly & (~a);   // falling edge condition

    // Register output signals, pulse high for one clock cycle when edge detected
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