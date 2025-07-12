module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_rise;
reg q_fall;

// internal clock signals
reg clk_rise;
reg clk_fall;

always @(posedge clk) begin
    clk_rise <= 1'b1;
    clk_fall <= 1'b0;
    q_rise <= d;
end

always @(negedge clk) begin
    clk_fall <= 1'b1;
    clk_rise <= 1'b0;
    q_fall <= d;
end

always @(posedge clk_rise or posedge clk_fall) begin
    if(clk_rise) begin
        q <= q_rise;
    end else if(clk_fall) begin
        q <= q_fall;
    end
end

// reset internal clocks when not used
always @(posedge clk_rise or posedge clk_fall) begin
    if(clk_rise) begin
        clk_fall <= 1'b0;
    end else if(clk_fall) begin
        clk_rise <= 1'b0;
    end
end

endmodule