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

// States
localparam IDLE = 2'b00;
localparam CALCULATE = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [2:0] cnt;
reg [15:0] SR;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg dividend_sign;
reg divisor_sign;

// Subtraction result
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, neg_divisor};
wire sub_ok = ~sub_result[8];  // No borrow means SR >= divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Capture signs and absolute values
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    abs_divisor <= sign && divisor[7] ? -divisor : divisor;
                    neg_divisor <= -(sign && divisor[7] ? -divisor : divisor);
                    
                    // Initialize SR with dividend shifted left by 1
                    SR <= {8'b0, (sign && dividend[7] ? -dividend : dividend)} << 1;
                    cnt <= 0;
                    state <= CALCULATE;
                end
            end
            
            CALCULATE: begin
                if (cnt == 3'd7) begin
                    state <= DONE;
                end else begin
                    cnt <= cnt + 1;
                end
                
                // Update SR
                if (sub_ok) begin
                    SR <= {sub_result[7:0], SR[7:0], 1'b1};
                end else begin
                    SR <= {SR[15:0], 1'b0};
                end
            end
            
            DONE: begin
                // Apply signs if signed operation
                if (sign) begin
                    result <= {
                        (dividend_sign ? -SR[15:8] : SR[15:8]),
                        ((dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0])
                    };
                end else begin
                    result <= SR;
                end
                
                res_valid <= 1;
                if (!opn_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule