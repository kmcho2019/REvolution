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

// States
typedef enum logic {
    IDLE,
    ACTIVE
} state_t;

// Internal signals
reg state;
reg [3:0] cnt;
reg [2*WIDTH-1:0] div_reg;  // {remainder, quotient}
reg [WIDTH-1:0] divisor_mag;
reg dividend_sign;
reg divisor_sign;
wire div_by_zero = (divisor == 0);

// Absolute values
wire [WIDTH-1:0] abs_dividend = (sign & dividend[WIDTH-1]) ? -dividend : dividend;
wire [WIDTH-1:0] abs_divisor = (sign & divisor[WIDTH-1]) ? -divisor : divisor;

// Division signals
wire [WIDTH:0] sub_result = {div_reg[2*WIDTH-1:WIDTH], 1'b0} + {1'b1, ~divisor_mag + 1'b1};
wire sub_positive = ~sub_result[WIDTH];
wire [WIDTH-1:0] next_remainder = sub_positive ? sub_result[WIDTH-1:0] : div_reg[2*WIDTH-2:WIDTH];
wire [WIDTH-1:0] next_quotient = {div_reg[WIDTH-2:0], sub_positive};

// Early termination
wire remainder_zero = (div_reg[2*WIDTH-1:WIDTH] == 0);
wire division_done = (cnt == WIDTH) || remainder_zero;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        div_reg <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Store signs and magnitudes
                    dividend_sign <= sign & dividend[WIDTH-1];
                    divisor_sign <= sign & divisor[WIDTH-1];
                    divisor_mag <= abs_divisor;
                    
                    // Initialize division registers
                    div_reg <= {{WIDTH{1'b0}}, abs_dividend};
                    cnt <= 0;
                    state <= ACTIVE;
                end
            end
            
            ACTIVE: begin
                if (division_done) begin
                    // Finalize result
                    res_valid <= 1;
                    if (div_by_zero) begin
                        result <= {2*WIDTH{1'b1}};  // Error code
                    end else begin
                        // Apply sign correction
                        result <= {
                            dividend_sign ? -div_reg[2*WIDTH-1:WIDTH] : div_reg[2*WIDTH-1:WIDTH],
                            (dividend_sign ^ divisor_sign) ? -div_reg[WIDTH-1:0] : div_reg[WIDTH-1:0]
                        };
                    end
                    state <= IDLE;
                end else begin
                    // Perform division step
                    div_reg <= {next_remainder, next_quotient};
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule