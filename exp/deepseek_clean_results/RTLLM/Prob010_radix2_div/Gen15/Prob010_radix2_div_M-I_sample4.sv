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
localparam IDLE = 3'b000;
localparam PREP = 3'b001;
localparam DIV  = 3'b010;
localparam DONE = 3'b100;

reg [3:0] cnt;
reg [15:0] SR;  // {remainder, quotient}
reg [7:0] divisor_mag;
reg quotient_sign;
reg divide_by_zero;
reg zero_dividend;
reg unity_divisor;

// Early termination signals
wire early_term = divide_by_zero | zero_dividend | unity_divisor;

// Non-restoring division signals
wire [8:0] add_result = {SR[15:8], 1'b0} + {1'b0, divisor_mag};
wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, ~divisor_mag + 1'b1};
wire [15:0] next_SR = SR[15] ? 
    {add_result[7:0], SR[7:1], 1'b0} : 
    {sub_result[7:0], SR[7:1], 1'b1};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        divisor_mag <= 0;
        quotient_sign <= 0;
        divide_by_zero <= 0;
        zero_dividend <= 0;
        unity_divisor <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Capture inputs and detect special cases
                    divide_by_zero <= (divisor == 0);
                    zero_dividend <= (dividend == 0);
                    unity_divisor <= (divisor == 1);
                    
                    // Calculate magnitudes and sign
                    divisor_mag <= (sign & divisor[7]) ? -divisor : divisor;
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    
                    // Initialize shift register with absolute dividend
                    SR <= {8'b0, (sign & dividend[7]) ? -dividend : dividend};
                    
                    state <= early_term ? DONE : PREP;
                end
            end
            
            PREP: begin
                // Single-cycle preparation (sign handling done in IDLE)
                state <= DIV;
                cnt <= 0;
            end
            
            DIV: begin
                if (cnt == 8) begin
                    // Final remainder adjustment if needed
                    if (SR[15]) begin
                        SR[15:8] <= SR[15:8] + divisor_mag;
                    end
                    state <= DONE;
                end else begin
                    SR <= next_SR;
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Handle all result cases
                if (divide_by_zero) begin
                    result <= {dividend, 8'hFF}; // IEEE 754 style NaN
                end else if (zero_dividend) begin
                    result <= 0;
                end else if (unity_divisor) begin
                    result <= {8'b0, (quotient_sign ? -dividend : dividend)};
                end else begin
                    result <= {
                        (sign & dividend[7]) ? -SR[15:8] : SR[15:8],
                        quotient_sign ? -SR[7:0] : SR[7:0]
                    };
                end
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule