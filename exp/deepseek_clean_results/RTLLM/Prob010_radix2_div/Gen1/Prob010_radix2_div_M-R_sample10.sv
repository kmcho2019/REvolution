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
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [3:0] cnt;
reg [15:0] SR;       // Shift register [remainder|quotient]
reg [7:0] divisor_abs;
reg [7:0] dividend_abs;
reg dividend_sign;
reg divisor_sign;

// Continuous assignments
wire [8:0] sub_result = SR[15:8] + (~divisor_abs + 1);
wire sub_ok = ~sub_result[8];  // 1 when remainder >= divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        SR <= 0;
        dividend_abs <= 0;
        divisor_abs <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    // Capture and convert inputs
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    dividend_abs <= dividend_sign ? -dividend : dividend;
                    divisor_abs <= divisor_sign ? -divisor : divisor;
                    
                    // Initialize shift register
                    SR <= {8'b0, dividend_abs, 1'b0};
                    cnt <= 0;
                    state <= CALC;
                end
            end
            
            CALC: begin
                if (cnt == 7) begin
                    state <= DONE;
                end else begin
                    // Perform division step
                    SR <= sub_ok ? 
                        {sub_result[7:0], SR[7:1], 1'b1} : 
                        {SR[14:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Apply sign correction if needed
                if (sign) begin
                    SR[15:8] <= (dividend_sign ^ divisor_sign) ? -SR[15:8] : SR[15:8];
                    SR[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
                end
                
                result <= {SR[15:8], SR[7:0]};
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
        
        // Clear valid when result is read
        if (res_valid && opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule