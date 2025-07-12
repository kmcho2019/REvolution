module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] SR;
reg [7:0] NEG_DIVISOR;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] temp_result;

wire [7:0] abs_dividend;
wire [7:0] abs_divisor;

assign abs_dividend = (sign && dividend[7]) ? (~dividend + 1) : dividend;
assign abs_divisor = (sign && divisor[7]) ? (~divisor + 1) : divisor;

assign NEG_DIVISOR = (~abs_divisor + 1);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        result <= 0;
    end else if (opn_valid && !res_valid) begin
        SR <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            temp_result <= {SR[7:0], SR[7:0]};
            start_cnt <= 0;
            cnt <= 0;
            res_valid <= 1;
        end else begin
            wire [8:0] sub_result;
            assign sub_result = {1'b0, SR} - {NEG_DIVISOR, 1'b0};
            if (sub_result[8]) begin
                SR <= {1'b0, SR} + {8'b0, 1'b0};
            end else begin
                SR <= {1'b1, SR} - {NEG_DIVISOR, 1'b0};
            end
            cnt <= cnt + 1;
        end
    end else if (!opn_valid && res_valid) begin
        res_valid <= 0;
    end
end

always @(posedge clk) begin
    if (res_valid) begin
        if (sign && (dividend[7] ^ divisor[7])) begin
            result <= {~temp_result[15:8] + 1, ~temp_result[7:0] + 1};
        end else if (sign && dividend[7] && !divisor[7]) begin
            result <= {temp_result[15:8], ~temp_result[7:0] + 1};
        end else begin
            result <= temp_result;
        end
    end
end

endmodule