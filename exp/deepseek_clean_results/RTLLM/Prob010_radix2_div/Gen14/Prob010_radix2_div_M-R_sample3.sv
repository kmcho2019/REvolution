module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output [15:0] result
);

// State definitions
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [2:0] cnt;
reg [15:0] acc;
reg q_sign, r_sign;
reg div_by_zero;

// Absolute value computations
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;
wire [7:0] neg_divisor = -abs_divisor;

// Intermediate signals
wire [8:0] sub_result = {acc[15:8], 1'b0} + {1'b0, neg_divisor};
wire sub_positive = ~sub_result[8];
wire [15:0] next_acc = sub_positive ? 
                       {sub_result[7:0], acc[7:0], 1'b1} : 
                       {acc[14:0], 1'b0};

// Final result computation
wire [7:0] final_remainder = acc[15] ? (acc[15:8] + abs_divisor) : acc[15:8];
wire [7:0] signed_remainder = r_sign ? -final_remainder : final_remainder;
wire [7:0] signed_quotient = q_sign ? -acc[7:0] : acc[7:0];
wire [15:0] normal_result = {signed_remainder, signed_quotient};
wire [15:0] error_result = {dividend, 8'hFF};

assign result = div_by_zero ? error_result : normal_result;

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        acc <= 0;
        res_valid <= 0;
        q_sign <= 0;
        r_sign <= 0;
        div_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    div_by_zero <= (divisor == 0);
                    r_sign <= sign & dividend[7];
                    q_sign <= (sign & dividend[7]) ^ (sign & divisor[7]);
                    acc <= {8'b0, abs_dividend};
                    cnt <= 0;
                    state <= CALC;
                end
            end
            
            CALC: begin
                acc <= next_acc;
                if (cnt == 3'd7) begin
                    state <= DONE;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule