module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract each digit for clarity
    wire [3:0] digit0 = q[3:0];
    wire [3:0] digit1 = q[7:4];
    wire [3:0] digit2 = q[11:8];
    wire [3:0] digit3 = q[15:12];

    // Internal registers for digits
    reg [3:0] d0, d1, d2, d3;

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
            ena <= 3'b000;
        end else begin
            // Increment ones digit
            if (d0 == 4'd9) begin
                d0 <= 4'd0;
                ena[0] <= 1'b1; // Enable tens digit increment
            end else begin
                d0 <= d0 + 4'd1;
                ena[0] <= 1'b0;
            end

            // Increment tens digit if enabled
            if (ena[0]) begin
                if (d1 == 4'd9) begin
                    d1 <= 4'd0;
                    ena[1] <= 1'b1; // Enable hundreds digit increment
                end else begin
                    d1 <= d1 + 4'd1;
                    ena[1] <= 1'b0;
                end
            end else begin
                ena[1] <= 1'b0;
            end

            // Increment hundreds digit if enabled
            if (ena[1]) begin
                if (d2 == 4'd9) begin
                    d2 <= 4'd0;
                    ena[2] <= 1'b1; // Enable thousands digit increment
                end else begin
                    d2 <= d2 + 4'd1;
                    ena[2] <= 1'b0;
                end
            end else begin
                ena[2] <= 1'b0;
            end

            // Increment thousands digit if enabled
            if (ena[2]) begin
                if (d3 == 4'd9) begin
                    d3 <= 4'd0;
                end else begin
                    d3 <= d3 + 4'd1;
                end
            end
        end
    end

    // Combine digits to output q
    always @(*) begin
        q = {d3, d2, d1, d0};
    end

endmodule