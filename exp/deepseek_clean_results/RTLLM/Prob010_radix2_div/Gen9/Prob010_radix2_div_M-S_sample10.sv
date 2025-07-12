module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [1:0] state;
reg [15:0] SR;  // Shift register: remainder[15:8] | quotient[7:0]
reg [2:0] cnt;
reg dividend_sign, divisor_sign;

localparam IDLE = 2'b00;
localparam CALCULATE = 2'b01;
localparam DONE = 2'b10;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        SR <= 0;
        cnt <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Store signs and initialize
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    
                    // Initialize shift register with absolute dividend
                    SR <= {8'b0, (sign & dividend[7]) ? -dividend : dividend};
                    cnt <= 0;
                    state <= (divisor == 0) ? DONE : CALCULATE;
                end
            end
            
            CALCULATE: begin
                SR <= SR << 1;  // Shift left
                
                // Subtract divisor if possible
                if (SR[15:8] >= ((sign & divisor[7]) ? -divisor : divisor)) begin
                    SR[15:8] <= SR[15:8] - ((sign & divisor[7]) ? -divisor : divisor);
                    SR[0] <= 1'b1;  // Set LSB
                end
                
                // Check completion
                if (cnt == 7) begin
                    state <= DONE;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Handle division by zero
                if (divisor == 0) begin
                    result <= {8'hFF, 8'hFF};  // Error code
                end
                // Apply sign correction
                else begin
                    result[15:8] <= dividend_sign ? -SR[15:8] : SR[15:8];  // Remainder
                    result[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];  // Quotient
                end
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule