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

    // Nominal flow outputs
    assign fr0 = (s != 3'b111);                    // Any level except above s[2]
    assign fr1 = (s == 3'b001) || (s == 3'b000);   // Between s[1]-s[0] or below
    assign fr2 = (s == 3'b000);                    // Below s[0] only

    // Supplemental flow (rising level or below s[0])
    assign dfr = (s > prev_s) || (s == 3'b000);

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;  // Initialize as if below s[0]
        end else begin
            prev_s <= s;
        end
    end

endmodule