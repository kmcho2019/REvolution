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

// State encoding
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [2:0] cnt;
reg [15:0] SR;
reg running;
reg quotient_sign;

// Absolute value calculations
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs = sign & divisor[7] ? -divisor : divisor;

// Division signals
wire division_done = (cnt == 3'd7);
wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, ~divisor_abs + 1'b1};
wire divide_by_zero = (divisor == 0);

// Next state logic
wire start_division = opn_valid && (state == IDLE);
wire processing = (state == CALC);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        result <= 0;
        res_valid <= 0;
        quotient_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (start_division) begin
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    if (divide_by_zero) begin
                        result <= {dividend, 8'hFF};
                        res_valid <= 1;
                        state <= DONE;
                    end else begin
                        SR <= {8'b0, dividend_abs};
                        cnt <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (division_done) begin
                    // Final remainder adjustment
                    if (SR[15]) SR[15:8] <= SR[15:8] + divisor_abs;
                    
                    // Apply sign correction
                    result <= {
                        sign & dividend[7] ? -SR[15:8] : SR[15:8],
                        quotient_sign ? -SR[7:0] : SR[7:0]
                    };
                    res_valid <= 1;
                    state <= DONE;
                end else begin
                    // Radix-2 division step
                    SR <= sub_result[8] ? 
                        {sub_result[7:0], SR[7:1], 1'b0} : 
                        {sub_result[7:0], SR[7:1], 1'b1};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                if (!opn_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule