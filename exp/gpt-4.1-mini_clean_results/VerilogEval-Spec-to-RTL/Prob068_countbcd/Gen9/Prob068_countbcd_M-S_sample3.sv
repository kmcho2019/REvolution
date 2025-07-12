module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);
    reg [3:0] d0, d1, d2, d3;  // Ones, Tens, Hundreds, Thousands digits
    reg ena1, ena2, ena3;

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
            ena1 <= 1'b0;
            ena2 <= 1'b0;
            ena3 <= 1'b0;
        end else begin
            ena1 <= 1'b0;
            ena2 <= 1'b0;
            ena3 <= 1'b0;

            // Increment ones digit
            if (d0 == 4'd9) begin
                d0 <= 4'd0;
                ena1 <= 1'b1; // Enable tens digit increment

                // Increment tens digit
                if (d1 == 4'd9) begin
                    d1 <= 4'd0;
                    ena2 <= 1'b1; // Enable hundreds digit increment

                    // Increment hundreds digit
                    if (d2 == 4'd9) begin
                        d2 <= 4'd0;
                        ena3 <= 1'b1; // Enable thousands digit increment

                        // Increment thousands digit
                        if (d3 == 4'd9)
                            d3 <= 4'd0;
                        else
                            d3 <= d3 + 4'd1;
                    end else
                        d2 <= d2 + 4'd1;
                end else
                    d1 <= d1 + 4'd1;
            end else
                d0 <= d0 + 4'd1;
        end
    end

    assign ena = {ena3, ena2, ena1};
    assign q = {d3, d2, d1, d0};

endmodule