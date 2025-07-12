module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;

    // Enable signals
    assign ena[0] = (counter[3:0] == 4'd9);                      // tens enable
    assign ena[1] = (counter[7:0] == 8'd99);                     // hundreds enable
    assign ena[2] = (counter[11:0] == 12'd999);                  // thousands enable

    assign q = counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Always increment ones digit
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
            end else begin
                counter[3:0] <= counter[3:0] + 4'd1;
            end

            // Increment tens digit if ones rolled over
            if (ena[0]) begin
                if (counter[7:4] == 4'd9) begin
                    counter[7:4] <= 4'd0;
                end else begin
                    counter[7:4] <= counter[7:4] + 4'd1;
                end
            end

            // Increment hundreds digit if tens rolled over
            if (ena[1]) begin
                if (counter[11:8] == 4'd9) begin
                    counter[11:8] <= 4'd0;
                end else begin
                    counter[11:8] <= counter[11:8] + 4'd1;
                end
            end

            // Increment thousands digit if hundreds rolled over
            if (ena[2]) begin
                if (counter[15:12] == 4'd9) begin
                    counter[15:12] <= 4'd0;
                end else begin
                    counter[15:12] <= counter[15:12] + 4'd1;
                end
            end
        end
    end

endmodule