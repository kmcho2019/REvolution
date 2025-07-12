module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;

    // Register the previous value of 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_dly <= 1'b0;
        else
            a_dly <= a;
    end

    // Detect edges by comparing current and previous 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_dly) & a;  // rising edge: previous 0, current 1
            down <= a_dly & (~a);  // falling edge: previous 1, current 0
        end
    end

endmodule