module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal enable signal
reg enable;

// Initialize q to a default value for a defined state at startup
initial begin
    q = 1'b0;
    enable = 1'b0;
end

// Always block to generate the enable signal on the positive edge of the clock
always @(posedge clk) begin
    enable <= 1'b1;
end

// Always block to update q based on the enable signal and input d
always @(*) begin
    if (enable) begin
        q <= d;
        enable <= 1'b0; // Reset enable after update
    end
end

endmodule