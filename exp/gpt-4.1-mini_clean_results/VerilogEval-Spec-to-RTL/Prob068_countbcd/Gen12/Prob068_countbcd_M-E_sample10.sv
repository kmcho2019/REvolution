module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] count;

    // BCD correction function: adds 6 (0x6) to any nibble > 9
    function [15:0] bcd_correct;
        input [15:0] val;
        reg [3:0] d0, d1, d2, d3;
    begin
        d0 = val[3:0];
        d1 = val[7:4];
        d2 = val[11:8];
        d3 = val[15:12];

        if (d0 > 4'd9) d0 = d0 + 4'd6;
        if (d1 > 4'd9) d1 = d1 + 4'd6;
        if (d2 > 4'd9) d2 = d2 + 4'd6;
        if (d3 > 4'd9) d3 = d3 + 4'd6;

        bcd_correct = {d3, d2, d1, d0};
    end
    endfunction

    // Enable signals: a digit enable is asserted if that digit reached 9 before increment
    wire ones_ena, tens_ena, hundreds_ena;
    assign ones_ena = (count[3:0] == 4'd9);
    assign tens_ena = (count[7:4] == 4'd9);
    assign hundreds_ena = (count[11:8] == 4'd9);

    assign ena = {hundreds_ena, tens_ena, ones_ena};

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            // Increment the entire count by 1
            reg [15:0] incremented;
            incremented = count + 16'd1;

            // Apply BCD correction to fix invalid digits (>9)
            count <= bcd_correct(incremented);
        end
    end

    assign q = count;

endmodule