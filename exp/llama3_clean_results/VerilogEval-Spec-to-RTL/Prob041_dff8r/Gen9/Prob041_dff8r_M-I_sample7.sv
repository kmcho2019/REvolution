module DFF(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] prev_d;

always @(posedge clk) begin
    if (reset) begin
        prev_d <= 8'b0;
    end else begin
        prev_d <= d;
    end
end

logic clk_enable;

assign clk_enable = (d != prev_d) || reset;

module DFF_Gated(
    input clk,
    input clk_enable,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always @(posedge clk) begin
    if (clk_enable) begin
        if (reset) begin
            q <= 8'b0;
        end else begin
            q <= d;
        end
    end
end

endmodule

DFF_Gated dff_gated(
    .clk(clk),
    .clk_enable(clk_enable),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule