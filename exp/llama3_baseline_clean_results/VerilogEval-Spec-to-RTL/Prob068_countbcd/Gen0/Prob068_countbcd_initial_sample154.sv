module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    assign q = {thousands, hundreds, tens, ones};

    always @ (posedge clk) begin
        if (reset) begin
            ones <= 0;
            tens <= 0;
            hundreds <= 0;
            thousands <= 0;
        end else begin
            if (ones == 9) begin
                ones <= 0;
                ena[0] <= 1;
            end else begin
                ones <= ones + 1;
                ena[0] <= 0;
            end

            if (ena[0] && tens == 9) begin
                tens <= 0;
                ena[1] <= 1;
            end else if (ena[0]) begin
                tens <= tens + 1;
                ena[1] <= 0;
            end else begin
                tens <= tens;
                ena[1] <= 0;
            end

            if (ena[1] && hundreds == 9) begin
                hundreds <= 0;
                ena[2] <= 1;
            end else if (ena[1]) begin
                hundreds <= hundreds + 1;
                ena[2] <= 0;
            end else begin
                hundreds <= hundreds;
                ena[2] <= 0;
            end

            if (ena[2] && thousands == 9) begin
                thousands <= 0;
            end else if (ena[2]) begin
                thousands <= thousands + 1;
            end else begin
                thousands <= thousands;
            end
        end
    end

endmodule