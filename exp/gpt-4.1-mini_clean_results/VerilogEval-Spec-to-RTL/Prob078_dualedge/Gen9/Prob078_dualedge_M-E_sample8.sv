module TopModule (
    input wire clk,
    input wire d,
    output reg q
);
    // Internal register to store previous clock value
    reg clk_dly;

    // Register to hold sampled data on posedge clk (master stage)
    reg d_pos;

    always @(posedge clk) begin
        d_pos <= d;      // Sample input on posedge
    end

    always @(posedge clk) begin
        clk_dly <= clk;  // Register delayed version of clk (will always be 1 at posedge)
    end

    wire neg_edge_detected = (clk_dly == 1'b1) && (clk == 1'b0);

    // Slave logic: on detecting falling edge of clk, update q with the sampled input
    always @(posedge clk or posedge neg_edge_detected) begin
        if (neg_edge_detected)
            q <= d;
        else
            q <= d_pos;
    end

endmodule