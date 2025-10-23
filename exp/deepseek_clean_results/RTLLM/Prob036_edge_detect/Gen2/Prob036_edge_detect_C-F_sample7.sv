module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_prev;  // Stores the previous value of 'a'
    wire rise_comb, down_comb;

    // Sequential part: store previous value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end
        else begin
            a_prev <= a;
        end
    end

    // Combinational part: edge detection
    assign rise_comb = a & ~a_prev;  // Rising edge detection
    assign down_comb = ~a & a_prev;  // Falling edge detection

    // Register outputs to prevent glitches
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end
        else begin
            rise <= rise_comb;
            down <= down_comb;
        end
    end

endmodule