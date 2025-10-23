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

// State definitions
localparam IDLE    = 2'b00;
localparam COMPUTE = 2'b01;
localparam DONE    = 2'b10;

reg [1:0] state, next_state;
reg [2:0] cnt;

// Data storage
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] sr;  // Shift register (remainder + quotient)
reg sign_reg;

// Combinational signals
wire [7:0] abs_dividend = (sign_reg & dividend_reg[7]) ? -dividend_reg : dividend_reg;
wire [7:0] abs_divisor = (sign_reg & divisor_reg[7]) ? -divisor_reg : divisor_reg;
wire [8:0] sub_result = {1'b0, sr[15:8]} - {1'b0, abs_divisor};
wire divisor_is_zero = (divisor_reg == 8'b0);
wire divisor_is_one = (abs_divisor == 8'b1);

// State transition logic
always @(*) begin
    case (state)
        IDLE:    next_state = (opn_valid && !divisor_is_zero) ? COMPUTE : IDLE;
        COMPUTE: next_state = (cnt == 3'd7) ? DONE : COMPUTE;
        DONE:    next_state = (!opn_valid) ? IDLE : DONE;
        default: next_state = IDLE;
    endcase
end

// Datapath control
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 3'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
        sr <= 16'b0;
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        sign_reg <= 1'b0;
    end else begin
        state <= next_state;
        
        case (state)
            IDLE: begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    sign_reg <= sign;
                    
                    if (divisor_is_zero) begin
                        result <= 16'hFFFF;
                        res_valid <= 1'b1;
                    end else if (divisor_is_one) begin
                        result <= {8'b0, (sign & dividend[7]) ? -dividend : dividend};
                        res_valid <= 1'b1;
                    end else begin
                        sr <= {8'b0, abs_dividend};
                        cnt <= 3'b0;
                    end
                end
            end
            
            COMPUTE: begin
                sr <= sub_result[8] ? 
                      {sr[14:0], 1'b0} : 
                      {sub_result[7:0], sr[7:0], 1'b1};
                cnt <= cnt + 1;
            end
            
            DONE: begin
                // Final remainder adjustment
                if (sr[15]) begin
                    sr[15:8] <= sr[15:8] + abs_divisor;
                end
                
                // Apply sign correction if signed operation
                if (sign_reg) begin
                    sr[7:0] <= (dividend_reg[7] ^ divisor_reg[7]) ? -sr[7:0] : sr[7:0];
                    sr[15:8] <= dividend_reg[7] ? -sr[15:8] : sr[15:8];
                end
                
                result <= sr;
                res_valid <= 1'b1;
            end
        endcase
    end
end

endmodule