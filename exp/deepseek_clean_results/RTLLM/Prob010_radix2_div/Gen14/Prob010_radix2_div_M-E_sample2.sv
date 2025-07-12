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
localparam IDLE = 0, PRESCALE = 1, DIVIDE = 2, CORRECT = 3, DONE = 4;

reg [2:0] state;
reg [2:0] cnt;
reg [15:0] acc;         // {remainder, quotient}
reg [7:0] scaled_divisor;
reg [7:0] scaled_remainder;
reg q_sign, r_sign;
reg div_by_zero;
reg trivial_case;

// Carry-save adder signals
wire [8:0] sum_path, carry_path;
wire [8:0] sum_result;

// Precompute absolute values
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;

// Carry-save adder implementation
assign sum_path = {1'b0, acc[15:8]} + {1'b0, scaled_divisor} + carry_path;
assign carry_path = ({1'b0, acc[15:8]} ^ {1'b0, scaled_divisor}) & 
                   ~({1'b0, acc[15:8]} ^ sum_path[7:0]);
assign sum_result = sum_path + (carry_path << 1);

// Quotient digit selection LUT
function [1:0] qsel;
    input [8:0] partial_remainder;
    begin
        casez(partial_remainder[8:7])
            2'b1?: qsel = 2'b00;  // Negative
            2'b01: qsel = 2'b01;  // Small positive
            default: qsel = 2'b10; // Large positive
        endcase
    end
endfunction

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        acc <= 0;
        res_valid <= 0;
        result <= 0;
        q_sign <= 0;
        r_sign <= 0;
        div_by_zero <= 0;
        trivial_case <= 0;
    end else begin
        case(state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Check for special cases
                    div_by_zero <= (divisor == 0);
                    trivial_case <= (abs_divisor > abs_dividend) || (abs_divisor == 1);
                    
                    // Store signs
                    q_sign <= (sign & dividend[7]) ^ (sign & divisor[7]);
                    r_sign <= sign & dividend[7];
                    
                    // Initialize with prescaled values
                    scaled_divisor <= abs_divisor << 1;
                    scaled_remainder <= abs_dividend;
                    acc <= {8'b0, abs_dividend};
                    state <= PRESCALE;
                end
            end
            
            PRESCALE: begin
                if (div_by_zero) begin
                    result <= {dividend, 8'hFF};
                    state <= DONE;
                end else if (trivial_case) begin
                    if (abs_divisor > abs_dividend) begin
                        result <= {abs_dividend, 8'b0};
                    end else begin // divisor == 1
                        result <= {8'b0, abs_dividend};
                    end
                    state <= CORRECT;
                end else begin
                    cnt <= 0;
                    state <= DIVIDE;
                end
            end
            
            DIVIDE: begin
                if (cnt == 3'd7) begin
                    state <= CORRECT;
                end else begin
                    // Parallel remainder calculation
                    case(qsel(acc[15:7]))
                        2'b00: begin // Negative remainder
                            acc <= {sum_result[7:0], acc[7:0], 1'b0};
                        end
                        2'b01: begin // Small positive
                            acc <= {sum_result[7:0] - scaled_divisor, acc[7:0], 1'b1};
                        end
                        default: begin // Large positive
                            acc <= {sum_result[7:0] - (scaled_divisor << 1), acc[7:0], 1'b1};
                        end
                    endcase
                    cnt <= cnt + 1;
                end
            end
            
            CORRECT: begin
                // Final remainder correction
                if (acc[15]) begin
                    acc[15:8] <= acc[15:8] + abs_divisor;
                end
                
                // Apply signs
                result <= {
                    r_sign ? -acc[15:8] : acc[15:8],
                    q_sign ? -acc[7:0] : acc[7:0]
                };
                state <= DONE;
            end
            
            DONE: begin
                res_valid <= 1;
                if (!opn_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule