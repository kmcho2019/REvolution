module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // BCD digits: q[3:0] = ones, q[7:4] = tens, q[11:8] = hundreds, q[15:12] = thousands

    // Internal wires for enables
    wire ones_rollover, tens_rollover, hundreds_rollover;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            ena <= 3'b000;
            // Increment ones digit
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                ena[0] <= 1'b1; // Enable tens increment
            end else begin
                q[3:0] <= q[3:0] + 1'b1;
            end

            // Increment tens digit if enabled
            if (ena[0]) begin
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                    ena[1] <= 1'b1; // Enable hundreds increment
                end else begin
                    q[7:4] <= q[7:4] + 1'b1;
                end
            end

            // Increment hundreds digit if enabled
            if (ena[1]) begin
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                    ena[2] <= 1'b1; // Enable thousands increment
                end else begin
                    q[11:8] <= q[11:8] + 1'b1;
                end
            end

            // Increment thousands digit if enabled
            if (ena[2]) begin
                if (q[15:12] == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= q[15:12] + 1'b1;
                end
            end
        end
    end

endmodule