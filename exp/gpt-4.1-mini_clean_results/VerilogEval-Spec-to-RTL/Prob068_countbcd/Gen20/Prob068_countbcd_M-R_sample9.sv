module TopModule (
    input         clk,
    input         reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Current digits as registers
    reg [3:0] d0, d1, d2, d3;

    // Next values and carry flags
    reg [3:0] d0_next, d1_next, d2_next, d3_next;
    reg c0, c1, c2;

    always @* begin
        // Default assignments
        d0_next = d0;
        d1_next = d1;
        d2_next = d2;
        d3_next = d3;
        c0 = 0;
        c1 = 0;
        c2 = 0;

        // Increment ones digit
        if (d0 == 4'd9) begin
            d0_next = 4'd0;
            c0 = 1;
        end else begin
            d0_next = d0 + 1'b1;
        end

        // Tens digit increments if ones digit rolled over
        if (c0) begin
            if (d1 == 4'd9) begin
                d1_next = 4'd0;
                c1 = 1;
            end else begin
                d1_next = d1 + 1'b1;
            end
        end

        // Hundreds digit increments if tens digit rolled over
        if (c1) begin
            if (d2 == 4'd9) begin
                d2_next = 4'd0;
                c2 = 1;
            end else begin
                d2_next = d2 + 1'b1;
            end
        end

        // Thousands digit increments if hundreds digit rolled over
        if (c2) begin
            if (d3 == 4'd9) begin
                d3_next = 4'd0;
            end else begin
                d3_next = d3 + 1'b1;
            end
        end

        // Enable signals for upper digits increments
        ena = {c2, c1, c0};
    end

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
            q  <= 16'd0;
        end else begin
            // Update only if changed (power optimization)
            if (d0_next != d0) d0 <= d0_next;
            if (d1_next != d1) d1 <= d1_next;
            if (d2_next != d2) d2 <= d2_next;
            if (d3_next != d3) d3 <= d3_next;

            q <= {d3, d2, d1, d0};
        end
    end

endmodule