module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract digits for convenience
    wire [3:0] digit0 = q[3:0];
    wire [3:0] digit1 = q[7:4];
    wire [3:0] digit2 = q[11:8];
    wire [3:0] digit3 = q[15:12];

    reg [3:0] d0, d1, d2, d3;
    reg e0, e1, e2;  // enables for digits 1,2,3

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
            e0 <= 1'b0;
            e1 <= 1'b0;
            e2 <= 1'b0;
        end else begin
            // increment ones digit
            if (d0 == 4'd9) begin
                d0 <= 4'd0;
                e0 <= 1'b1; // enable increment of tens digit
            end else begin
                d0 <= d0 + 1'b1;
                e0 <= 1'b0;
            end

            // increment tens digit if enabled
            if (e0) begin
                if (d1 == 4'd9) begin
                    d1 <= 4'd0;
                    e1 <= 1'b1; // enable increment of hundreds digit
                end else begin
                    d1 <= d1 + 1'b1;
                    e1 <= 1'b0;
                end
            end else begin
                e1 <= 1'b0;
            end

            // increment hundreds digit if enabled
            if (e1) begin
                if (d2 == 4'd9) begin
                    d2 <= 4'd0;
                    e2 <= 1'b1; // enable increment of thousands digit
                end else begin
                    d2 <= d2 + 1'b1;
                    e2 <= 1'b0;
                end
            end else begin
                e2 <= 1'b0;
            end

            // increment thousands digit if enabled
            if (e2) begin
                if (d3 == 4'd9) begin
                    d3 <= 4'd0;
                end else begin
                    d3 <= d3 + 1'b1;
                end
            end
        end
    end

    always @(*) begin
        q = {d3, d2, d1, d0};
        ena = {e2, e1, e0};
    end

endmodule