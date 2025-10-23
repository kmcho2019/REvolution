module TopModule(
    input clk,
    input d,
    output reg q
);

reg enable;

// Clock-controlled enable signal
always @(posedge clk) begin
    enable <= 1'b1;
end

always @(negedge clk) begin
    enable <= 1'b0;
end

// SR latch with clock-controlled enable
always @(*) begin
    if (enable) begin
        q <= d;
    end
end

endmodule