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
reg [3:0] cnt;  // Counts 0-8 for 8 iterations
reg [15:0] sr;   // Shift register {remainder, quotient}
reg q_sign;      // Quotient sign
reg r_sign;      // Remainder sign
reg div_zero;    // Division by zero flag
reg simple;      // Simple case flag (dividend < divisor)

// Combinational calculations
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;
wire [8:0] sub_result = {sr[15:8], 1'b0} + {1'b0, ~abs_divisor + 1'b1};
wire sub_ok = ~sub_result[8];  // No borrow means subtraction successful

// Next state logic
wire start_calc = (state == IDLE) & opn_valid;
wire calc_complete = (state == CALC) & (cnt == 4'd8);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        sr <= 0;
        result <= 0;
        res_valid <= 0;
        q_sign <= 0;
        r_sign <= 0;
        div_zero <= 0;
        simple <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Register absolute values and signs
                    q_sign <= sign & (dividend[7] ^ divisor[7]);
                    r_sign <= sign & dividend[7];
                    div_zero <= (divisor == 0);
                    simple <= (abs_dividend < abs_divisor);
                    
                    // Initialize shift register
                    sr <= {8'b0, abs_dividend};
                    cnt <= 0;
                    state <= CALC;
                end
            end
            
            CALC: begin
                if (div_zero | simple) begin
                    // Handle special cases immediately
                    state <= DONE;
                end else if (calc_complete) begin
                    // Final remainder adjustment if needed
                    if (sr[15]) begin
                        sr[15:8] <= sr[15:8] + abs_divisor;
                    end
                    state <= DONE;
                end else begin
                    // Radix-2 division step
                    sr <= sub_ok ? 
                        {sub_result[7:0], sr[7:0], 1'b1} : 
                        {sr[15:8], sr[7:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Format output result
                if (div_zero) begin
                    result <= {abs_dividend, 8'hFF};  // Division by zero
                end else if (simple) begin
                    result <= {abs_dividend, 8'b0};  // Simple case
                end else begin
                    // Normal case with sign correction
                    result <= {
                        r_sign ? -sr[15:8] : sr[15:8],
                        q_sign ? -sr[7:0] : sr[7:0]
                    };
                end
                res_valid <= 1;
                
                // Return to idle when operation completes
                if (!opn_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule