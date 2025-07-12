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

// States
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [3:0] cnt;
reg [15:0] SR;       // Shift register: [remainder|quotient]
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg dividend_sign;
reg divisor_sign;

// Continuous assignments
wire [7:0] dividend_twos_comp = -dividend;
wire [7:0] divisor_twos_comp = -divisor;
wire [8:0] sub_result = SR[15:8] + (-divisor_abs);
wire carry_out = sub_result[8];
wire [7:0] remainder_final = dividend_sign ? -SR[15:8] : SR[15:8];
wire [7:0] quotient_final = (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
assign result = {remainder_final, quotient_final};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Capture and convert inputs
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    dividend_abs <= dividend_sign ? dividend_twos_comp : dividend;
                    divisor_abs <= divisor_sign ? divisor_twos_comp : divisor;
                    
                    // Initialize shift register
                    SR <= {8'b0, dividend_abs, 1'b0};
                    cnt <= 0;
                    state <= CALC;
                end
            end
            
            CALC: begin
                if (cnt == 7) begin
                    state <= DONE;
                end else begin
                    // Perform subtraction and shift
                    SR <= carry_out ? 
                          {sub_result[7:0], SR[7:1], 1'b1} : 
                          {SR[14:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                res_valid <= 1;
                if (opn_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule