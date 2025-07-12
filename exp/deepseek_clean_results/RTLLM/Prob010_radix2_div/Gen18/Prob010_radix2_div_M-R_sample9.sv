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

// One-hot state encoding
localparam IDLE = 3'b001;
localparam CALC = 3'b010;
localparam DONE = 3'b100;

reg [2:0] state;
reg [2:0] cnt;
reg [15:0] SR;
reg quotient_sign;

// Absolute value precomputation
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs = sign & divisor[7] ? -divisor : divisor;
wire divide_by_zero = (divisor == 0);

// Division signals
wire division_done = (cnt == 3'd7);
wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, ~divisor_abs + 1'b1};

// State transition conditions
wire start_division = opn_valid && (state == IDLE);
wire processing = (state == CALC);
wire result_consumed = !opn_valid && (state == DONE);

// Next state logic
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
                if (result_consumed) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule