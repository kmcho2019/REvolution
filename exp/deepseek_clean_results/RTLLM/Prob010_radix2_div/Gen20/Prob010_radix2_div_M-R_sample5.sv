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
parameter IDLE = 2'b00;
parameter CALC = 2'b01;
parameter DONE = 2'b10;

reg [1:0] state, next_state;
reg [3:0] cnt;
reg [15:0] sr;
reg q_sign, r_sign;
reg div_zero, simple;

// Absolute value calculations
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;

// Subtraction result
wire [8:0] sub_result = {sr[15:8], 1'b0} + {1'b0, ~abs_divisor + 1'b1};
wire sub_ok = ~sub_result[8];

// State transition logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE: if (opn_valid) next_state = CALC;
        CALC: if (div_zero || simple || cnt == 4'd8) next_state = DONE;
        DONE: if (!opn_valid) next_state = IDLE;
    endcase
end

// Datapath control
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        sr <= 0;
        q_sign <= 0;
        r_sign <= 0;
        div_zero <= 0;
        simple <= 0;
    end else begin
        state <= next_state;
        
        case (next_state)
            IDLE: begin
                cnt <= 0;
                res_valid <= 0;
            end
            
            CALC: begin
                if (state == IDLE) begin
                    // Initialize on start
                    sr <= {8'b0, abs_dividend};
                    q_sign <= sign & (dividend[7] ^ divisor[7]);
                    r_sign <= sign & dividend[7];
                    div_zero <= (divisor == 0);
                    simple <= (abs_dividend < abs_divisor);
                    cnt <= 0;
                end else if (!div_zero && !simple) begin
                    // Normal division step
                    sr <= sub_ok ? 
                        {sub_result[7:0], sr[7:0], 1'b1} : 
                        {sr[15:8], sr[7:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Final remainder adjustment
                if (!div_zero && !simple && sr[15])
                    sr[15:8] <= sr[15:8] + abs_divisor;
                
                // Output formatting
                if (div_zero)
                    result <= {abs_dividend, 8'hFF};
                else if (simple)
                    result <= {abs_dividend, 8'b0};
                else
                    result <= {
                        r_sign ? -sr[15:8] : sr[15:8],
                        q_sign ? -sr[7:0] : sr[7:0]
                    };
                
                res_valid <= 1;
            end
        endcase
    end
end

endmodule