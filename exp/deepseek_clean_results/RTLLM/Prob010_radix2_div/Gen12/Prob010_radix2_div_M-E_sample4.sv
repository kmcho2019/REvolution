module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result  // {remainder[15:8], quotient[7:0]}
);

localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [3:0] cnt;
reg [7:0] divisor_abs;
reg [15:0] partial;  // {remainder, quotient}
reg result_sign;
wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs_wire = (sign & divisor[7]) ? -divisor : divisor;
wire division_by_zero = (divisor == 0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        partial <= 0;
        res_valid <= 0;
        result <= 0;
        divisor_abs <= 0;
        result_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    result_sign <= sign & (dividend[7] ^ divisor[7]);
                    divisor_abs <= divisor_abs_wire;
                    
                    if (division_by_zero) begin
                        result <= 16'hFFFF;  // Error value
                        state <= DONE;
                    end else begin
                        partial <= {8'b0, dividend_abs};
                        state <= CALC;
                        cnt <= 0;
                    end
                end
            end
            
            CALC: begin
                if (cnt == 7) begin
                    // Final step - correct remainder if negative
                    if (partial[15]) begin
                        partial[15:8] <= partial[15:8] + divisor_abs;
                    end
                    state <= DONE;
                end else begin
                    // Non-restoring division step
                    if (partial[15]) begin
                        partial <= {partial[14:0], 1'b0};
                        partial[15:8] <= partial[15:8] + divisor_abs;
                    end else begin
                        partial <= {partial[14:0], 1'b0};
                        partial[15:8] <= partial[15:8] - divisor_abs;
                    end
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Apply sign correction and format output
                result[15:8] <= result_sign ? -partial[15:8] : partial[15:8];
                result[7:0] <= result_sign ? -partial[7:0] : partial[7:0];
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule