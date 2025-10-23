module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Function to increment 4-digit BCD by one with carry propagation
    function [15:0] bcd_increment;
        input [15:0] val;
        reg [3:0] d0, d1, d2, d3;
        begin
            d0 = val[3:0];
            d1 = val[7:4];
            d2 = val[11:8];
            d3 = val[15:12];

            // Increment ones digit
            if (d0 == 4'd9) begin
                d0 = 4'd0;
                // Increment tens digit
                if (d1 == 4'd9) begin
                    d1 = 4'd0;
                    // Increment hundreds digit
                    if (d2 == 4'd9) begin
                        d2 = 4'd0;
                        // Increment thousands digit, roll over after 9
                        if (d3 == 4'd9)
                            d3 = 4'd0;
                        else
                            d3 = d3 + 4'd1;
                    end else begin
                        d2 = d2 + 4'd1;
                    end
                end else begin
                    d1 = d1 + 4'd1;
                end
            end else begin
                d0 = d0 + 4'd1;
            end

            bcd_increment = {d3, d2, d1, d0};
        end
    endfunction

    // Generate enable signals for upper digits based on current count
    assign ena[0] = (bcd_count[3:0] == 4'd9);
    assign ena[1] = ena[0] && (bcd_count[7:4] == 4'd9);
    assign ena[2] = ena[1] && (bcd_count[11:8] == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            bcd_count <= bcd_increment(bcd_count);
        end
    end

    assign q = bcd_count;

endmodule