module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Combinational block to compute next BCD count and enable signals
    // ena[0] = increment enable for tens digit
    // ena[1] = increment enable for hundreds digit
    // ena[2] = increment enable for thousands digit
    // Returns next_count and ena vector
    function [19:0] bcd_inc_ena;
        input [15:0] val;
        reg [3:0] d0, d1, d2, d3;
        reg c0, c1, c2;
        reg [3:0] n0, n1, n2, n3;
        reg [2:0] ena_local;
        begin
            d0 = val[3:0];
            d1 = val[7:4];
            d2 = val[11:8];
            d3 = val[15:12];

            // Increment ones digit
            if (d0 == 4'd9) begin
                n0 = 4'd0;
                c0 = 1'b1;
            end else begin
                n0 = d0 + 1'b1;
                c0 = 1'b0;
            end

            // Increment tens digit if c0
            if (c0) begin
                if (d1 == 4'd9) begin
                    n1 = 4'd0;
                    c1 = 1'b1;
                end else begin
                    n1 = d1 + 1'b1;
                    c1 = 1'b0;
                end
            end else begin
                n1 = d1;
                c1 = 1'b0;
            end

            // Increment hundreds digit if c1
            if (c1) begin
                if (d2 == 4'd9) begin
                    n2 = 4'd0;
                    c2 = 1'b1;
                end else begin
                    n2 = d2 + 1'b1;
                    c2 = 1'b0;
                end
            end else begin
                n2 = d2;
                c2 = 1'b0;
            end

            // Increment thousands digit if c2
            if (c2) begin
                if (d3 == 4'd9)
                    n3 = 4'd0;
                else
                    n3 = d3 + 1'b1;
            end else begin
                n3 = d3;
            end

            // ena outputs: enable signals for digits [3:1] increment
            ena_local = {c2, c1, c0};

            // Pack next count and ena in single output: {ena[2:0], next_count[15:0]}
            bcd_inc_ena = {ena_local, n3, n2, n1, n0};
        end
    endfunction

    wire [19:0] inc_out = bcd_inc_ena(bcd_count);

    wire [2:0] ena_comb = inc_out[19:17];
    wire [15:0] next_count = inc_out[15:0];

    // Clock enable: update register only if count changes (power saving)
    wire ce = (next_count != bcd_count);

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else if (ce) begin
            bcd_count <= next_count;
        end
    end

    assign ena = ena_comb;
    assign q = bcd_count;

endmodule