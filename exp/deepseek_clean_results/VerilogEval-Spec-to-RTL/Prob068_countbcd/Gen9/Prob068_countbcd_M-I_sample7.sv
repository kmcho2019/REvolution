module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal signals
    wire ones_ovf = (q[3:0] == 4'd9);
    wire tens_ovf = (q[7:4] == 4'd9) & ones_ovf;
    wire hundreds_ovf = (q[11:8] == 4'd9) & tens_ovf;
    
    // Registered enable signals
    always @(posedge clk) begin
        if (reset) begin
            ena <= 3'b0;
        end else begin
            ena[0] <= ones_ovf;
            ena[1] <= tens_ovf;
            ena[2] <= hundreds_ovf;
        end
    end

    // Main counter logic
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            // Increment ones digit
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                // Increment tens if ones overflows
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                    // Increment hundreds if tens overflows
                    if (q[11:8] == 4'd9) begin
                        q[11:8] <= 4'd0;
                        // Increment thousands if hundreds overflows
                        q[15:12] <= (q[15:12] == 4'd9) ? 4'd0 : q[15:12] + 4'd1;
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