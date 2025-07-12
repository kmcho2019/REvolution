module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [2:0] state;
reg [2:0] cnt;
reg [15:0] sr;  // shift register {remainder, quotient}
reg [7:0] divisor_abs;
reg dividend_sign, divisor_sign;
reg div_by_zero;

localparam IDLE = 0;
localparam DIVIDE = 1;
localparam DONE = 2;

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs_wire = (sign & divisor[7]) ? -divisor : divisor;

wire [8:0] sub_result = {sr[15:8], 1'b0} + {1'b1, ~divisor_abs + 1'b1};
wire sub_positive = ~sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
        div_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    divisor_abs <= divisor_abs_wire;
                    div_by_zero <= (divisor == 0);
                    sr <= {8'b0, dividend_abs};
                    cnt <= 0;
                    state <= DIVIDE;
                end
            end
            
            DIVIDE: begin
                if (div_by_zero) begin
                    result <= {8'hFF, 8'hFF};  // Error value
                    state <= DONE;
                end else if (cnt == 3'd7) begin
                    // Final result
                    sr <= {sub_positive ? sub_result[7:0] : sr[14:8], 
                           {sr[6:0], sub_positive}};
                    state <= DONE;
                end else begin
                    // Normal division step
                    sr <= {sub_positive ? sub_result[7:0] : sr[14:8], 
                          {sr[6:0], sub_positive}};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                if (!div_by_zero) begin
                    // Apply sign correction
                    result <= {
                        dividend_sign ? -sr[15:8] : sr[15:8],
                        (dividend_sign ^ divisor_sign) ? -sr[7:0] : sr[7:0]
                    };
                end
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule