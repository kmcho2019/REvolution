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

// Pipeline registers - optimized structure
typedef struct packed {
    logic [7:0] div;
    logic [7:0] divisor;
    logic [16:0] sr; // {remainder, quotient, lsb}
    logic sign;
    logic dividend_sign;
    logic divisor_sign;
    logic valid;
    logic div_by_zero;
} pipe_stage_t;

pipe_stage_t [7:0] pipe_reg;

// Combinational signals
wire [7:0] neg_divisor = -divisor;
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;
wire current_div_by_zero = (divisor == 0);

// Pipeline stage 0 (input)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        pipe_reg[0] <= '{
            div: 8'b0,
            divisor: 8'b0,
            sr: 17'b0,
            sign: 1'b0,
            dividend_sign: 1'b0,
            divisor_sign: 1'b0,
            valid: 1'b0,
            div_by_zero: 1'b0
        };
    end else begin
        pipe_reg[0].div <= abs_dividend;
        pipe_reg[0].divisor <= abs_divisor;
        pipe_reg[0].sr <= {8'b0, abs_dividend, 1'b0};
        pipe_reg[0].sign <= sign;
        pipe_reg[0].dividend_sign <= sign & dividend[7];
        pipe_reg[0].divisor_sign <= sign & divisor[7];
        pipe_reg[0].valid <= opn_valid;
        pipe_reg[0].div_by_zero <= current_div_by_zero;
    end
end

// Pipeline stages 1-7 (division steps)
genvar i;
generate
    for (i = 1; i < 8; i = i + 1) begin : pipeline_stages
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                pipe_reg[i] <= '{
                    div: 8'b0,
                    divisor: 8'b0,
                    sr: 17'b0,
                    sign: 1'b0,
                    dividend_sign: 1'b0,
                    divisor_sign: 1'b0,
                    valid: 1'b0,
                    div_by_zero: 1'b0
                };
            end else begin
                // Propagate control and divisor signals
                pipe_reg[i].valid <= pipe_reg[i-1].valid;
                pipe_reg[i].div_by_zero <= pipe_reg[i-1].div_by_zero;
                pipe_reg[i].sign <= pipe_reg[i-1].sign;
                pipe_reg[i].dividend_sign <= pipe_reg[i-1].dividend_sign;
                pipe_reg[i].divisor_sign <= pipe_reg[i-1].divisor_sign;
                pipe_reg[i].divisor <= pipe_reg[i-1].divisor;
                
                // Division step with early termination
                if (pipe_reg[i-1].div_by_zero) begin
                    pipe_reg[i].sr <= pipe_reg[i-1].sr;
                end else if (pipe_reg[i-1].sr[16:9] >= pipe_reg[i-1].divisor) begin
                    pipe_reg[i].sr <= {
                        pipe_reg[i-1].sr[16:9] - pipe_reg[i-1].divisor,
                        pipe_reg[i-1].sr[8:1], 
                        1'b1
                    };
                end else begin
                    pipe_reg[i].sr <= {
                        pipe_reg[i-1].sr[16:9], 
                        pipe_reg[i-1].sr[8:1], 
                        1'b0
                    };
                end
            end
        end
    end
endgenerate

// Output stage with error handling
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
    end else begin
        res_valid <= pipe_reg[7].valid;
        
        if (pipe_reg[7].div_by_zero) begin
            // Standardized error code: MSB set for error, remainder=FF, quotient=FF
            result <= 16'hFFFF;
        end else begin
            // Apply sign correction to final result
            result <= {
                pipe_reg[7].dividend_sign ? -pipe_reg[7].sr[16:9] : pipe_reg[7].sr[16:9],
                (pipe_reg[7].dividend_sign ^ pipe_reg[7].divisor_sign) ? 
                    -pipe_reg[7].sr[8:1] : pipe_reg[7].sr[8:1]
            };
        end
    end
end

endmodule