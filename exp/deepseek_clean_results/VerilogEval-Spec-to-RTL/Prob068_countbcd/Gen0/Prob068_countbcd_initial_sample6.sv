module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;
    reg [2:0] enable;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'b0;
            tens <= 4'b0;
            hundreds <= 4'b0;
            thousands <= 4'b0;
            enable <= 3'b0;
        end else begin
            // Default enable signals
            enable <= 3'b0;

            // Ones digit logic
            if (ones == 4'd9) begin
                ones <= 4'd0;
                enable[0] <= 1'b1;  // Enable tens increment
            end else begin
                ones <= ones + 4'd1;
            end

            // Tens digit logic
            if (enable[0]) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    enable[1] <= 1'b1;  // Enable hundreds increment
                end else begin
                    tens <= tens + 4'd1;
                end
            end

            // Hundreds digit logic
            if (enable[1]) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    enable[2] <= 1'b1;  // Enable thousands increment
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end

            // Thousands digit logic
            if (enable[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};
    assign ena = enable;

endmodule