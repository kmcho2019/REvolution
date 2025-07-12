module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] counter;

    // Function to increment a 4-digit BCD number (16 bits) by 1
    // Each digit: 4 bits BCD (0-9)
    function [15:0] bcd_increment;
        input [15:0] val;
        reg [3:0] d0, d1, d2, d3; // digits: ones, tens, hundreds, thousands
        reg c0, c1, c2;
    begin
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

        // Increment tens digit if carry from ones
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

        // Increment hundreds digit if carry from tens
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

        // Increment thousands digit if carry from hundreds
        if (c2) begin
            if (d3 == 4'd9) begin
                d3 = 4'd0; // rolls over at 9999 -> 0000
            end else begin
                d3 = d3 + 4'd1;
            end
        end

        bcd_increment = {d3, d2, d1, d0};
    end
    endfunction

    wire [15:0] next_counter = bcd_increment(counter);

    // Generate ena signals by checking if corresponding lower digits roll over from 9 to 0
    // ena[0]: ones digit wraps from 9 to 0 on next increment
    // ena[1]: tens digit wraps from 9 to 0 on next increment (implies ones digit was 9 and tens is 9)
    // ena[2]: hundreds digit wraps from 9 to 0 on next increment (implies ones, tens, hundreds digits were 9)
    assign ena[0] = (counter[3:0] == 4'd9);
    assign ena[1] = ena[0] && (counter[7:4] == 4'd9);
    assign ena[2] = ena[1] && (counter[11:8] == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            counter <= next_counter;
        end
    end

    assign q = counter;

endmodule