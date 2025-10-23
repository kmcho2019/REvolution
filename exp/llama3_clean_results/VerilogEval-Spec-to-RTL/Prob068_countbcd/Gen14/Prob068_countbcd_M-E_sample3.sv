module BCD4_Counter(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (count == 16'd9999) begin
            count <= 16'd0;
        end else begin
            // Increment ones digit
            if (count[3:0] == 4'd9) begin
                count[3:0] <= 4'd0;
                // Increment tens digit
                if (count[7:4] == 4'd9) begin
                    count[7:4] <= 4'd0;
                    // Increment hundreds digit
                    if (count[11:8] == 4'd9) begin
                        count[11:8] <= 4'd0;
                        // Increment thousands digit
                        count[15:12] <= count[15:12] + 1;
                    end else begin
                        count[11:8] <= count[11:8] + 1;
                    end
                end else begin
                    count[7:4] <= count[7:4] + 1;
                end
            end else begin
                count[3:0] <= count[3:0] + 1;
            end
        end
    end
end

assign q = count;

// Generate enable signals based on the current count
assign ena[0] = (count[3:0] == 4'd9);
assign ena[1] = (count[7:4] == 4'd9) && (count[3:0] == 4'd9);
assign ena[2] = (count[11:8] == 4'd9) && (count[7:4] == 4'd9) && (count[3:0] == 4'd9);

endmodule