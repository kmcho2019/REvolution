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

// Pipeline registers
reg [7:0] div_pipe [0:7];
reg [7:0] divisor_pipe [0:7];
reg [16:0] sr_pipe [0:7]; // {remainder, quotient, lsb}
reg sign_pipe [0:7];
reg [1:0] dividend_sign_pipe [0:7];
reg [1:0] divisor_sign_pipe [0:7];
reg valid_pipe [0:7];
reg div_by_zero_pipe [0:7];

// Combinational signals
wire [7:0] neg_divisor = -divisor;
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;
wire current_div_by_zero = (divisor == 0);

// Pipeline stage 0 (input)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        valid_pipe[0] <= 0;
        div_by_zero_pipe[0] <= 0;
    end else begin
        div_pipe[0] <= abs_dividend;
        divisor_pipe[0] <= abs_divisor;
        sr_pipe[0] <= {8'b0, abs_dividend, 1'b0};
        sign_pipe[0] <= sign;
        dividend_sign_pipe[0] <= sign & dividend[7];
        divisor_sign_pipe[0] <= sign & divisor[7];
        valid_pipe[0] <= opn_valid;
        div_by_zero_pipe[0] <= current_div_by_zero;
    end
end

// Pipeline stages 1-7 (division steps)
genvar i;
generate
    for (i = 1; i < 8; i = i + 1) begin : pipeline_stages
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                valid_pipe[i] <= 0;
                div_by_zero_pipe[i] <= 0;
            end else begin
                // Propagate control signals
                valid_pipe[i] <= valid_pipe[i-1];
                div_by_zero_pipe[i] <= div_by_zero_pipe[i-1];
                sign_pipe[i] <= sign_pipe[i-1];
                dividend_sign_pipe[i] <= dividend_sign_pipe[i-1];
                divisor_sign_pipe[i] <= divisor_sign_pipe[i-1];
                
                // Propagate divisor
                divisor_pipe[i] <= divisor_pipe[i-1];
                
                // Division step
                if (div_by_zero_pipe[i-1]) begin
                    sr_pipe[i] <= sr_pipe[i-1]; // No change if div by zero
                end else if (sr_pipe[i-1][16:9] >= divisor_pipe[i-1]) begin
                    sr_pipe[i] <= {sr_pipe[i-1][16:9] - divisor_pipe[i-1], 
                                  sr_pipe[i-1][8:1], 1'b1};
                end else begin
                    sr_pipe[i] <= {sr_pipe[i-1][16:9], sr_pipe[i-1][8:1], 1'b0};
                end
            end
        end
    end
endgenerate

// Output stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
    end else begin
        res_valid <= valid_pipe[7];
        
        if (div_by_zero_pipe[7]) begin
            result <= 16'hFFFF; // Error pattern for divide by zero
        end else begin
            // Apply sign correction
            result <= {
                dividend_sign_pipe[7] ? -sr_pipe[7][16:9] : sr_pipe[7][16:9],
                (dividend_sign_pipe[7] ^ divisor_sign_pipe[7]) ? 
                    -sr_pipe[7][8:1] : sr_pipe[7][8:1]
            };
        end
    end
end

endmodule