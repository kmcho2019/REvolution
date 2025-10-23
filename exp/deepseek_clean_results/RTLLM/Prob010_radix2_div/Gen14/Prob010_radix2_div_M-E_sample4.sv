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

// Pipeline stages
localparam PREP = 2'b00;
localparam DIV = 2'b01;
localparam NORM = 2'b10;

reg [1:0] stage;
reg [3:0] cnt;
reg [15:0] SR;  // {remainder, quotient}

// Pipeline registers
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg quotient_sign;
reg divide_by_zero;

// Non-restoring division signals
wire [8:0] add_result = {SR[15:8], 1'b0} + {1'b0, divisor_abs};
wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, -divisor_abs};
wire [15:0] next_SR = SR[15] ? 
    {add_result[7:0], SR[7:1], 1'b0} : 
    {sub_result[7:0], SR[7:1], 1'b1};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage <= PREP;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        dividend_abs <= 0;
        divisor_abs <= 0;
        quotient_sign <= 0;
        divide_by_zero <= 0;
    end else begin
        case (stage)
            PREP: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Pre-processing stage
                    dividend_abs <= (sign & dividend[7]) ? -dividend : dividend;
                    divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    divide_by_zero <= (divisor == 0);
                    
                    if (divisor == 0) begin
                        // Handle divide by zero immediately
                        result <= {dividend, 8'hFF};
                        res_valid <= 1;
                        stage <= PREP;
                    end else begin
                        // Initialize division
                        SR <= {8'b0, dividend_abs};
                        cnt <= 0;
                        stage <= DIV;
                    end
                end
            end
            
            DIV: begin
                // Division stage (non-restoring algorithm)
                if (cnt == 8) begin
                    // Final remainder adjustment if needed
                    if (SR[15]) begin
                        SR[15:8] <= SR[15:8] + divisor_abs;
                    end
                    stage <= NORM;
                end else begin
                    SR <= next_SR;
                    cnt <= cnt + 1;
                end
            end
            
            NORM: begin
                // Post-processing stage
                result <= {
                    (sign & dividend[7]) ? -SR[15:8] : SR[15:8],
                    quotient_sign ? -SR[7:0] : SR[7:0]
                };
                res_valid <= 1;
                stage <= PREP;
            end
        endcase
    end
end

endmodule