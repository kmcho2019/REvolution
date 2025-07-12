module radix2_div #(
    parameter WIDTH = 8
) (
    input clk,
    input rst,
    input sign,
    input [WIDTH-1:0] dividend,
    input [WIDTH-1:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [2*WIDTH-1:0] result
);

// States
localparam IDLE = 1'b0;
localparam CALC = 1'b1;

reg state;
reg [2:0] cnt;  // Reduced from 4 bits since we only count to 8
reg [2*WIDTH-1:0] div_reg;  // Combines remainder (upper) and quotient (lower)
reg quotient_sign;
reg divide_by_zero;

// Absolute values
wire [WIDTH-1:0] dividend_abs = sign & dividend[WIDTH-1] ? -dividend : dividend;
wire [WIDTH-1:0] divisor_abs = sign & divisor[WIDTH-1] ? -divisor : divisor;
wire [WIDTH-1:0] divisor_neg = -divisor_abs;

// Subtraction logic with carry lookahead
wire [WIDTH:0] sub_result = {1'b0, div_reg[2*WIDTH-1:WIDTH]} + {1'b0, divisor_neg};
wire sub_ok = ~sub_result[WIDTH];  // 1 if remainder >= divisor

// Control signals
wire op_start = opn_valid && !res_valid;
wire calc_done = (cnt == WIDTH-1);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        div_reg <= 0;
        quotient_sign <= 0;
        divide_by_zero <= 0;
    end else begin
        res_valid <= 0;  // Default
        
        case (state)
            IDLE: begin
                if (op_start) begin
                    divide_by_zero <= (divisor == 0);
                    quotient_sign <= sign & (dividend[WIDTH-1] ^ divisor[WIDTH-1]);
                    
                    if (divisor == 0) begin
                        // Handle divide by zero immediately
                        result <= {dividend, {WIDTH{1'b1}}};
                        res_valid <= 1;
                    end else begin
                        // Initialize division register
                        div_reg <= {dividend_abs, {WIDTH{1'b0}}};
                        cnt <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (calc_done) begin
                    // Finalize result with sign handling
                    result[2*WIDTH-1:WIDTH] <= sign & dividend[WIDTH-1] ? 
                                             -div_reg[2*WIDTH-1:WIDTH] : 
                                             div_reg[2*WIDTH-1:WIDTH];
                    result[WIDTH-1:0] <= quotient_sign ? 
                                       -div_reg[WIDTH-1:0] : 
                                       div_reg[WIDTH-1:0];
                    res_valid <= 1;
                    state <= IDLE;
                end else begin
                    // Perform division step
                    if (sub_ok) begin
                        div_reg <= {sub_result[WIDTH-1:0], div_reg[WIDTH-2:0], 1'b1};
                    end else begin
                        div_reg <= {div_reg[2*WIDTH-2:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule