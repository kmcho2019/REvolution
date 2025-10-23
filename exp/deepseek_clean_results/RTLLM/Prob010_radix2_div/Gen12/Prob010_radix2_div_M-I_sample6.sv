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

localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [15:0] SR;        // {remainder, quotient}
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg quotient_sign;
reg input_valid;

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, neg_divisor};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        SR <= 16'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 4'b0;
        quotient_sign <= 1'b0;
        input_valid <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    input_valid <= 1'b1;
                    if (divisor == 8'b0) begin
                        // Handle divide by zero
                        result <= {dividend, 8'hFF};
                        res_valid <= 1'b1;
                        state <= DONE;
                    end else begin
                        // Initialize division
                        SR <= {8'b0, dividend_abs};
                        neg_divisor <= -divisor_abs;
                        quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                        cnt <= 4'b0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (cnt == 4'd8) begin
                    // Finalize result
                    result <= {
                        (sign & dividend[7]) ? -SR[15:8] : SR[15:8],
                        quotient_sign ? -SR[7:0] : SR[7:0]
                    };
                    res_valid <= 1'b1;
                    state <= DONE;
                end else begin
                    // Division step
                    SR <= sub_result[8] ? 
                          {sub_result[7:0], SR[7:1], 1'b1} : 
                          {SR[14:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                if (input_valid && !opn_valid) begin
                    input_valid <= 1'b0;
                end
                if (!input_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule