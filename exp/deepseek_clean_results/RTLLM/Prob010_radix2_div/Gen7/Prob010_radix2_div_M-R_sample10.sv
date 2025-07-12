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
reg [3:0] cnt;
reg [15:0] SR;       // Shift register: [remainder|quotient]
reg [7:0] divisor_reg;

// Absolute value calculations
wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;
wire [7:0] divisor_neg = -divisor_abs;

// Division signals
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, divisor_neg};
wire carry_out = ~sub_result[8];  // Positive result means no borrow
wire [15:0] next_SR = carry_out ? {sub_result[7:0], SR[7:0], 1'b1} : {SR[14:0], 1'b0};

// Sign correction
wire [7:0] final_remainder = (sign & dividend[7]) ? -SR[15:8] : SR[15:8];
wire [7:0] final_quotient = ((sign & dividend[7]) ^ (sign & divisor[7])) ? -SR[7:0] : SR[7:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        divisor_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    SR <= {8'b0, dividend_abs, 1'b0};
                    divisor_reg <= divisor_abs;
                    cnt <= 0;
                    state <= CALC;
                    res_valid <= 0;
                end
            end
            
            CALC: begin
                SR <= next_SR;
                cnt <= cnt + 1;
                
                if (cnt == 7) begin
                    state <= DONE;
                end
            end
            
            DONE: begin
                res_valid <= 1;
                if (divisor == 0) begin
                    result <= {8'hFF, 8'hFF}; // Divide by zero
                end else begin
                    result <= {final_remainder, final_quotient};
                end
                
                if (opn_valid) begin
                    state <= IDLE;
                    res_valid <= 0;
                end
            end
        endcase
    end
end

endmodule