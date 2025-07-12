module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);
    reg [15:0] bcd_count;

    // Internal wires for each digit (4 bits)
    wire [3:0] d0 = bcd_count[3:0];     // ones
    wire [3:0] d1 = bcd_count[7:4];     // tens
    wire [3:0] d2 = bcd_count[11:8];    // hundreds
    wire [3:0] d3 = bcd_count[15:12];   // thousands

    // Wires for incremented digits and carries
    reg [3:0] d0_next, d1_next, d2_next, d3_next;
    reg       c0, c1, c2; // carries between digits

    // Sequential logic: update the 16-bit counter each clock cycle
    always @(posedge clk) begin
        if (reset)
            bcd_count <= 16'd0;
        else
            bcd_count <= {d3_next, d2_next, d1_next, d0_next};
    end

    // Combinational logic: increment BCD counter with ripple carry
    always @(*) begin
        // Increment ones digit by 1
        if (d0 == 4'd9) begin
            d0_next = 4'd0;
            c0 = 1'b1;
        end else begin
            d0_next = d0 + 4'd1;
            c0 = 1'b0;
        end

        // Increment tens digit if carry from ones
        if (c0) begin
            if (d1 == 4'd9) begin
                d1_next = 4'd0;
                c1 = 1'b1;
            end else begin
                d1_next = d1 + 4'd1;
                c1 = 1'b0;
            end
        end else begin
            d1_next = d1;
            c1 = 1'b0;
        end

        // Increment hundreds digit if carry from tens
        if (c1) begin
            if (d2 == 4'd9) begin
                d2_next = 4'd0;
                c2 = 1'b1;
            end else begin
                d2_next = d2 + 4'd1;
                c2 = 1'b0;
            end
        end else begin
            d2_next = d2;
            c2 = 1'b0;
        end

        // Increment thousands digit if carry from hundreds
        if (c2) begin
            if (d3 == 4'd9)
                d3_next = 4'd0;
            else
                d3_next = d3 + 4'd1;
        end else begin
            d3_next = d3;
        end
    end

    // ena signals indicate when the tens, hundreds, and thousands digits increment
    assign ena[0] = c0;      // ones rollover causes tens increment enable
    assign ena[1] = c1;      // tens rollover causes hundreds increment enable
    assign ena[2] = c2;      // hundreds rollover causes thousands increment enable

    // Output the BCD counter
    assign q = bcd_count;

endmodule