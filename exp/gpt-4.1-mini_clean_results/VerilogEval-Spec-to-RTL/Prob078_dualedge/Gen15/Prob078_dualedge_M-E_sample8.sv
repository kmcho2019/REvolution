module TopModule (
    input wire clk,
    input wire d,
    output reg q
);

    reg d_posedge_sample;

    // Sample input on positive edge of clock
    always @(posedge clk) begin
        d_posedge_sample <= d;
    end

    // Update output q on negative edge of clock with data sampled on previous positive edge
    always @(negedge clk) begin
        q <= d_posedge_sample;
    end

endmodule