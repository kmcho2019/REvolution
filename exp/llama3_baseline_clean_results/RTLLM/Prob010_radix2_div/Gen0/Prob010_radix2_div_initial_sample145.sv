module radix2_div(
    input clk, 
    input rst, 
    input sign, 
    input [7:0] dividend, 
    input [7:0] divisor, 
    input opn_valid, 
    output res_valid, 
    output [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [8:0] sr; // Shift register
reg [7:0] neg_divisor; // Negated absolute value of divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Start counter signal
reg [15:0] result_reg; // Result register
reg res_valid_reg; // Result validity register

// FSM states
reg [1:0] state;
localparam IDLE = 2'b00;
localparam OPERATION = 2'b01;
localparam RESULT = 2'b10;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        result_reg <= 0;
        sr <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid &&!res_valid_reg) begin
                    state <= OPERATION;
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    neg_divisor <= ~divisor + 1;
                    if (sign) begin
                        // Signed division
                        if (dividend[7] == 1) begin
                            sr <= {1'b0, ~dividend + 1};
                        end else begin
                            sr <= {1'b0, dividend};
                        end
                    end else begin
                        // Unsigned division
                        sr <= {1'b0, dividend};
                    end
                    cnt <= 1;
                    start_cnt <= 1;
                end
            end
            OPERATION: begin
                if (start_cnt) begin
                    if (cnt == 8) begin
                        state <= RESULT;
                        start_cnt <= 0;
                        cnt <= 0;
                        if (sign) begin
                            // Signed division
                            if (dividend_reg[7] == 1) begin
                                result_reg <= {sr[8:1], sr[0:7]};
                            end else begin
                                result_reg <= {sr[8:1], sr[0:7]};
                            end
                        end else begin
                            // Unsigned division
                            result_reg <= {sr[8:1], sr[0:7]};
                        end
                    end else begin
                        reg [8:0] sub;
                        sub <= sr[7:0] - neg_divisor;
                        if (sub[8] == 1) begin
                            // No borrow
                            sr <= {1'b0, sr[7:0]} + {8'b1, sub[7:0]};
                        end else begin
                            // Borrow
                            sr <= {1'b1, sr[7:0]} + {8'b0, sub[7:0]};
                        end
                        cnt <= cnt + 1;
                    end
                end
            end
            RESULT: begin
                res_valid_reg <= 1;
                if (!opn_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign res_valid = res_valid_reg;
assign result = result_reg;

endmodule