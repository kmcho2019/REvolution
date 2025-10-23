module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] ena_int;

// Ones digit counter
always @(posedge clk) begin
    if (reset) begin
        ones <= 0;
    end else if (ones == 9) begin
        ones <= 0;
        ena_int[0] <= 1;
    end else begin
        ones <= ones + 1;
        ena_int[0] <= 0;
    end
end

// Tens digit counter
always @(posedge clk) begin
    if (reset) begin
        tens <= 0;
    end else if (ena_int[0] && tens == 9) begin
        tens <= 0;
        ena_int[1] <= 1;
    end else if (ena_int[0]) begin
        tens <= tens + 1;
        ena_int[1] <= 0;
    end else begin
        ena_int[1] <= 0;
    end
end

// Hundreds digit counter
always @(posedge clk) begin
    if (reset) begin
        hundreds <= 0;
    end else if (ena_int[1] && hundreds == 9) begin
        hundreds <= 0;
        ena_int[2] <= 1;
    end else if (ena_int[1]) begin
        hundreds <= hundreds + 1;
        ena_int[2] <= 0;
    end else begin
        ena_int[2] <= 0;
    end
end

// Thousands digit counter
always @(posedge clk) begin
    if (reset) begin
        thousands <= 0;
    end else if (ena_int[2] && thousands == 9) begin
        thousands <= 0;
    end else if (ena_int[2]) begin
        thousands <= thousands + 1;
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;
assign ena = ena_int;

endmodule