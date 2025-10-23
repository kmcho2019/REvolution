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
    output reg [2*WIDTH-1:0] result  // {remainder, quotient}
);

// State encoding
localparam IDLE = 1'b0;
localparam ACTIVE = 1'b1;

reg state;
reg [3:0] cnt;
reg [2*WIDTH-1:0] div_reg;  // {remainder, quotient}

// Absolute value calculations
wire [WIDTH-1:0] abs_dividend = (sign & dividend[WIDTH-1]) ? -dividend : dividend;
wire [WIDTH-1:0] abs_divisor = (sign & divisor[WIDTH-1]) ? -divisor : divisor;

// Sign storage
reg dividend_sign;
reg divisor_sign;
reg [WIDTH-1:0] divisor_mag;

// Division signals
wire [WIDTH:0] sub_result = {div_reg[2*WIDTH-1:WIDTH], 1'b0} + {1'b1, ~divisor_mag + 1'b1};
wire sub_positive = ~sub_result[WIDTH];
wire [WIDTH-1:0] next_remainder = sub_positive ? sub_result[WIDTH-1:0] : div_reg[2*WIDTH-2:WIDTH];
wire [WIDTH-1:0] next_quotient = {div_reg[WIDTH-2:0], sub_positive};

// Control signals
wire div_by_zero = (divisor == 0);
wire remainder_zero = (div_reg[2*WIDTH-1:WIDTH] == 0);
wire division_done = (cnt == WIDTH) || remainder_zero;
wire load_inputs = (state == IDLE) && opn_valid && !res_valid;

// Next state logic
wire next_state = (state == IDLE) ? (load_inputs ? ACTIVE : IDLE) :
                 (division_done ? IDLE : ACTIVE);

// Output logic
wire [2*WIDTH-1:0] final_result = div_by_zero ? {2*WIDTH{1'b1}} :
    {dividend_sign ? -div_reg[2*WIDTH-1:WIDTH] : div_reg[2*WIDTH-1:WIDTH],
     (dividend_sign ^ divisor_sign) ? -div_reg[WIDTH-1:0] : div_reg[WIDTH-1:0]};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        div_reg <= 0;
        res_valid <= 0;
        result <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
        divisor_mag <= 0;
    end else begin
        state <= next_state;
        res_valid <= (state == ACTIVE) && division_done;
        
        if (load_inputs) begin
            dividend_sign <= sign & dividend[WIDTH-1];
            divisor_sign <= sign & divisor[WIDTH-1];
            divisor_mag <= abs_divisor;
            div_reg <= {{WIDTH{1'b0}}, abs_dividend};
            cnt <= 0;
        end else if (state == ACTIVE && !division_done) begin
            div_reg <= {next_remainder, next_quotient};
            cnt <= cnt + 1;
        end
        
        if (res_valid) begin
            result <= final_result;
        end
    end
end

endmodule