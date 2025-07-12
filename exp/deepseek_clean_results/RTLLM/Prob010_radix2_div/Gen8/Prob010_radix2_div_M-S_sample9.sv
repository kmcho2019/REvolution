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
reg [15:0] sr;       // Shift register: {remainder, quotient}
reg [7:0] divisor_abs;
reg dividend_sign;
reg divisor_sign;
reg div_by_zero;

localparam IDLE = 0;
localparam CALCULATE = 1;
localparam DONE = 2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Store signs and absolute values
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
                    div_by_zero <= (divisor == 0);
                    
                    // Initialize shift register
                    sr <= {8'b0, (sign & dividend[7]) ? -dividend : dividend};
                    cnt <= 0;
                    state <= CALCULATE;
                end
            end
            
            CALCULATE: begin
                if (cnt == 3'd7) begin
                    state <= DONE;
                end else begin
                    // Perform one division step
                    if (sr[15:8] >= divisor_abs) begin
                        sr <= {(sr[15:8] - divisor_abs), sr[7:0], 1'b1};
                    end else begin
                        sr <= {sr[15:8], sr[7:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                res_valid <= 1;
                if (div_by_zero) begin
                    result <= 16'hFFFF;  // Error value for divide by zero
                end else begin
                    // Apply sign correction
                    result <= {
                        dividend_sign ? -sr[15:8] : sr[15:8],
                        (dividend_sign ^ divisor_sign) ? -sr[7:0] : sr[7:0]
                    };
                end
                state <= IDLE;
            end
        endcase
    end
end

endmodule