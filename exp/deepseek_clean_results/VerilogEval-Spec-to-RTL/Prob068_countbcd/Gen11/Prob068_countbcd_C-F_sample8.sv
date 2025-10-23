module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;
    
    assign q = {thousands, hundreds, tens, ones};
    
    // Registered enable signals
    always @(posedge clk) begin
        if (reset) begin
            ena <= 3'b0;
        end else begin
            ena[0] <= (ones == 4'd9);
            ena[1] <= (ones == 4'd9) && (tens == 4'd9);
            ena[2] <= (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9);
        end
    end
    
    // Ones digit (always increments)
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
        end else begin
            ones <= (ones == 4'd9) ? 4'd0 : ones + 1;
        end
    end
    
    // Tens digit (increments when ones overflows)
    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'd0;
        end else if (ena[0]) begin
            tens <= (tens == 4'd9) ? 4'd0 : tens + 1;
        end
    end
    
    // Hundreds digit (increments when tens overflows)
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
        end else if (ena[1]) begin
            hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 1;
        end
    end
    
    // Thousands digit (increments when hundreds overflows)
    always @(posedge clk) begin
        if (reset) begin
            thousands <= 4'd0;
        end else if (ena[2]) begin
            thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 1;
        end
    end

endmodule