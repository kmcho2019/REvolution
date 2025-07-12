module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Pipeline stages
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] quotient;
reg [8:0] remainder;
reg [3:0] cnt;

// Stage 1: Input handling
always @(posedge clk or posedge rst) begin
    if (rst) begin
        abs_dividend <= 8'd0;
        abs_divisor <= 8'd0;
    end else if (opn_valid) begin
        abs_dividend <= (sign && dividend[7])? ~dividend + 1 : dividend;
        abs_divisor <= (sign && divisor[7])? ~divisor + 1 : divisor;
    end
end

// Stage 2: Initialization
reg start_div;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        start_div <= 1'b0;
        remainder <= 9'd0;
        quotient <= 8'd0;
        cnt <= 4'd0;
    end else if (opn_valid) begin
        start_div <= 1'b1;
        remainder <= {1'b0, abs_dividend};
        quotient <= 8'd0;
        cnt <= 4'd1;
    end
end

// Stage 3: Subtraction and quotient calculation
reg [8:0] sub_result;
always @(*) begin
    if (remainder[8]) begin
        sub_result = {remainder[7:0], 1'b0} - {1'b0, abs_divisor};
    end else begin
        sub_result = {remainder[7:0], 1'b0};
    end
end

always @(posedge clk) begin
    if (start_div && cnt < 4'd8) begin
        remainder <= sub_result;
        quotient <= quotient + (sub_result[8]? (1 << (cnt - 1)) : 0);
        cnt <= cnt + 1;
    end
end

// Stage 4: Result formation
always @(posedge clk) begin
    if (start_div && cnt == 4'd8) begin
        result <= {remainder[7:0], quotient};
        res_valid <= 1'b1;
        start_div <= 1'b0;
    end
end

// Clock gating for power efficiency
always @(posedge clk) begin
    if (!start_div) begin
        // Disable pipeline stages when not in use
    end
end

endmodule