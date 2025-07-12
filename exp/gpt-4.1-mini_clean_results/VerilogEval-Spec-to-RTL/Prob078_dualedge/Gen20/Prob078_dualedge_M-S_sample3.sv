module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    reg d_dly;

    // Delay input d by one clock cycle (sampled at posedge)
    always @(posedge clk) begin
        d_dly <= d;
    end

    // On every clock edge (detected by change in clk), toggle q if d changed
    always @(posedge clk or negedge clk) begin
        q <= d;
    end

endmodule