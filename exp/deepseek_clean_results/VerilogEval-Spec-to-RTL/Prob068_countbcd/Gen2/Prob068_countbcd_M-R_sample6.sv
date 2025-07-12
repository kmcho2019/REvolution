module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;

    // Enable signals
    assign ena[0] = (counter[3:0] == 4'd9);  // Tens enable
    assign ena[1] = ena[0] && (counter[7:4] == 4'd9;  // Hundreds enable
    assign ena[2] = ena[1] && (counter[11:8] == 4'd9;  // Thousands enable

    // Output assignment
    assign q = counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Increment ones digit
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
                // Increment tens digit if needed
                if (ena[0]) begin
                    if (counter[7:4] == 4'd9) begin
                        counter[7:4] <= 4'd0;
                        // Increment hundreds digit if needed
                        if (ena[1]) begin
                            if (counter[11:8] == 4'd9) begin
                                counter[11:8] <= 4'd0;
                                // Increment thousands digit if needed
                                if (ena[2]) begin
                                    counter[15:12] <= (counter[15:12] == 4'd9) ? 4'd0 : counter[15:12] + 4'd1;
                                end
                            end else begin
                                counter[11:8] <= counter[11:8] + 4'd1;
                            end
                        end
                    end else begin
                        counter[7:4] <= counter[7:4] + 4'd1;
                    end
                end
            end else begin
                counter[3:0] <= counter[3:0] + 4'd1;
            end
        end
    end

endmodule