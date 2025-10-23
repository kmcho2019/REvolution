module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] prev_s;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Nominal flow outputs
    assign fr0 = (reset) ? 1'b1 : (s != 3'b111);
    assign fr1 = (reset) ? 1'b1 : (s == 3'b001 || s == 3'b000);
    assign fr2 = (reset) ? 1'b1 : (s == 3'b000);

    // Supplemental flow (rising level detection)
    assign dfr = (reset) ? 1'b1 : ((s > prev_s) && (s != 3'b111));

endmodule