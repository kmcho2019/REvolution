module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Each digit occupies 4 bits:
    // q[3:0]: ones
    // q[7:4]: tens
    // q[11:8]: hundreds
    // q[15:12]: thousands

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
            ena <= 3'b0;
        end else begin
            // Default ena signals are 0
            ena <= 3'b0;

            // Increment ones digit
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                // Enable tens digit increment
                ena[0] <= 1'b1;

                // Check tens digit for carry
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                    ena[1] <= 1'b1;

                    // Check hundreds digit for carry
                    if (q[11:8] == 4'd9) begin
                        q[11:8] <= 4'd0;
                        ena[2] <= 1'b1;

                        // Increment thousands digit with carry wrap-around
                        if (q[15:12] == 4'd9)
                            q[15:12] <= 4'd0;
                        else
                            q[15:12] <= q[15:12] + 4'd1;
                    end else begin
                        q[11:8] <= q[11:8] + 4'd1;
                    end
                end else begin
                    q[7:4] <= q[7:4] + 4'd1;
                end
            end else begin
                q[3:0] <= q[3:0] + 4'd1;
            end
        end
    end

endmodule