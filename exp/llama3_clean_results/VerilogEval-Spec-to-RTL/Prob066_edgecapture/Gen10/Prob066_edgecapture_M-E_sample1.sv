module EdgeDetector(
    input  clk,
    input  reset,
    input  in,
    output reg out = 1'b0
);

reg prev_in = 1'b0;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 1'b0;
        out <= 1'b0;
    end else begin
        if (~in && prev_in) begin
            out <= 1'b1;
        end else begin
            out <= 1'b0;
        end
        prev_in <= in;
    end
end

endmodule

module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out = 32'd0
);

EdgeDetector edge_detector[31:0] (
   .clk(clk),
   .reset(reset),
   .in(in),
   .out(out)
);

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (edge_detector[i].out) begin
                out[i] <= 1'b1;
            end
        end
    end
end

endmodule