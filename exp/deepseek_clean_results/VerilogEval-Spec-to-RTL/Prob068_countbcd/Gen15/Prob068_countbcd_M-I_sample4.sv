module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal signals for overflow detection
    wire ones_overflow = (q[3:0] == 4'd9);
    wire tens_overflow = (q[7:4] == 4'd9) & ones_overflow;
    wire hundreds_overflow = (q[11:8] == 4'd9) & tens_overflow;
    
    // Registered enable signals
    always @(posedge clk) begin
        if (reset) begin
            ena <= 3'b0;
        end else begin
            ena[0] <= ones_overflow;
            ena[1] <= tens_overflow;
            ena[2] <= hundreds_overflow;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            // Increment ones digit
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                // Increment tens digit if needed
                if (ena[0]) begin
                    if (q[7:4] == 4'd9) begin
                        q[7:4] <= 4'd0;
                        // Increment hundreds digit if needed
                        if (ena[1]) begin
                            if (q[11:8] == 4'd9) begin
                                q[11:8] <= 4'd0;
                                // Increment thousands digit if needed
                                if (ena[2]) begin
                                    q[15:12] <= (q[15:12] == 4'd9) ? 4'd0 : q[15:12] + 4'd1;
                                end
                            end else begin
                                q[11:8] <= q[11:8] + 4'd1;
                            end
                        end
                    end else begin
                        q[7:4] <= q[7:4] + 4'd1;
                    end
                end
            end else begin
                q[3:0] <= q[3:0] + 4'd1;
            end
        end
    end

endmodule