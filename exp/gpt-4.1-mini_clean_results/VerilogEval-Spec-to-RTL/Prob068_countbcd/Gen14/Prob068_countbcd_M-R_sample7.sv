module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);
    reg [3:0] d0, d1, d2, d3;

    wire c0 = (d0 == 4'd9);
    wire c1 = c0 && (d1 == 4'd9);
    wire c2 = c1 && (d2 == 4'd9);

    assign ena = {c2, c1, c0};

    wire [3:0] d0_next = c0 ? 4'd0 : d0 + 4'd1;
    wire [3:0] d1_next = c0 ? (c1 ? 4'd0 : d1 + 4'd1) : d1;
    wire [3:0] d2_next = c1 ? (c2 ? 4'd0 : d2 + 4'd1) : d2;
    wire [3:0] d3_next = c2 ? (d3 == 4'd9 ? 4'd0 : d3 + 4'd1) : d3;

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
        end else begin
            d0 <= d0_next;
            d1 <= d1_next;
            d2 <= d2_next;
            d3 <= d3_next;
        end
    end

    assign q = {d3, d2, d1, d0};

endmodule