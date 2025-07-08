module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg [2:0]   ena,
    output reg [15:0]  q
);

    // Split q into digits for clarity
    wire [3:0] d0 = q[3:0];   // ones
    wire [3:0] d1 = q[7:4];   // tens
    wire [3:0] d2 = q[11:8];  // hundreds
    wire [3:0] d3 = q[15:12]; // thousands

    reg [3:0] digit0, digit1, digit2, digit3;

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
            ena <= 3'b000;
        end else begin
            // Increment ones digit
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;
                ena[0] <= 1'b1; // enable increment tens
            end else begin
                digit0 <= digit0 + 4'd1;
                ena[0] <= 1'b0;
            end

            // Increment tens digit if enabled
            if (ena[0]) begin
                if (digit1 == 4'd9) begin
                    digit1 <= 4'd0;
                    ena[1] <= 1'b1; // enable increment hundreds
                end else begin
                    digit1 <= digit1 + 4'd1;
                    ena[1] <= 1'b0;
                end
            end else begin
                ena[1] <= 1'b0;
            end

            // Increment hundreds digit if enabled
            if (ena[1]) begin
                if (digit2 == 4'd9) begin
                    digit2 <= 4'd0;
                    ena[2] <= 1'b1; // enable increment thousands
                end else begin
                    digit2 <= digit2 + 4'd1;
                    ena[2] <= 1'b0;
                end
            end else begin
                ena[2] <= 1'b0;
            end

            // Increment thousands digit if enabled
            if (ena[2]) begin
                if (digit3 == 4'd9) begin
                    digit3 <= 4'd0;
                end else begin
                    digit3 <= digit3 + 4'd1;
                end
            end
        end
    end

    // Pack digits into output q
    always @(*) begin
        q = {digit3, digit2, digit1, digit0};
    end

endmodule