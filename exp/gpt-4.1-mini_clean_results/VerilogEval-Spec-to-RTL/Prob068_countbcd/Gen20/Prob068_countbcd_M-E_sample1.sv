module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Function to increment 4-digit BCD with carry handling
    function [15:0] bcd_increment;
        input [15:0] val;
        reg [3:0] d0, d1, d2, d3;
        reg c0, c1, c2;
        begin
            // Extract digits
            d0 = val[3:0];
            d1 = val[7:4];
            d2 = val[11:8];
            d3 = val[15:12];

            // Increment ones digit
            if (d0 == 4'd9) begin
                d0 = 4'd0;
                c0 = 1'b1;
            end else begin
                d0 = d0 + 4'd1;
                c0 = 1'b0;
            end

            // Increment tens if carry from ones
            if (c0) begin
                if (d1 == 4'd9) begin
                    d1 = 4'd0;
                    c1 = 1'b1;
                end else begin
                    d1 = d1 + 4'd1;
                    c1 = 1'b0;
                end
            end else begin
                c1 = 1'b0;
            end

            // Increment hundreds if carry from tens
            if (c1) begin
                if (d2 == 4'd9) begin
                    d2 = 4'd0;
                    c2 = 1'b1;
                end else begin
                    d2 = d2 + 4'd1;
                    c2 = 1'b0;
                end
            end else begin
                c2 = 1'b0;
            end

            // Increment thousands if carry from hundreds
            if (c2) begin
                if (d3 == 4'd9) begin
                    d3 = 4'd0; // roll over after 9999
                end else begin
                    d3 = d3 + 4'd1;
                end
            end

            bcd_increment = {d3, d2, d1, d0};
        end
    endfunction

    // Enable signals: ena[0] for tens increment, ena[1] for hundreds, ena[2] for thousands
    assign ena[0] = (bcd_count[3:0] == 4'd9);
    assign ena[1] = ena[0] && (bcd_count[7:4] == 4'd9);
    assign ena[2] = ena[1] && (bcd_count[11:8] == 4'd9);

    // Output the BCD count
    assign q = bcd_count;

    // Sequential logic: update count at posedge clk or reset
    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            bcd_count <= bcd_increment(bcd_count);
        end
    end

endmodule