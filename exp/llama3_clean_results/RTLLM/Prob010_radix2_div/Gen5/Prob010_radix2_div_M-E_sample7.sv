module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Controller
reg [2:0] state;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
    end else begin
        case (state)
            0: begin
                if (opn_valid) begin
                    state <= 1;
                end
            end
            1: begin
                if (result_ready) begin
                    state <= 2;
                end
            end
            2: begin
                if (!opn_valid) begin
                    state <= 0;
                end
            end
        endcase
    end
end

// Data Path
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [8:0] shift_reg;
reg [3:0] cnt;
reg [1:0] sign_detector;
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
        sign_detector <= 0;
    end else begin
        case (state)
            1: begin
                // Initialize registers
                dividend_reg <= dividend;
                divisor_reg <= divisor;
                shift_reg <= {1'b0, dividend_reg};  // shift left by one bit
                cnt <= 1;
                sign_detector <= sign;
            end
            2: begin
                // Update shift register
                if (cnt < 8) begin
                    if (shift_reg[8] == 0) begin
                        // Subtract divisor
                        if (shift_reg[7:0] >= divisor_reg) begin
                            shift_reg <= {1'b0, shift_reg[7:0] - divisor_reg} << 1;  // shift left and insert carry-out
                        end else begin
                            shift_reg <= {1'b1, shift_reg[7:0]} << 1;  // shift left and insert carry-out
                        end
                    end else begin
                        // Subtract divisor
                        if ({shift_reg[8], shift_reg[7:0]} >= {1'b0, divisor_reg}) begin
                            shift_reg <= {1'b0, shift_reg[7:0] - divisor_reg} << 1;  // shift left and insert carry-out
                        end else begin
                            shift_reg <= {1'b1, shift_reg[7:0]} << 1;  // shift left and insert carry-out
                        end
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

// Result Formatter
reg result_ready;
always @(posedge clk) begin
    if (rst) begin
        result_ready <= 0;
    end else begin
        case (state)
            2: begin
                if (cnt == 8) begin
                    result_ready <= 1;
                end
            end
            0: begin
                result_ready <= 0;
            end
        endcase
    end
end

// Output Logic
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            2: begin
                if (result_ready) begin
                    res_valid <= 1;
                    result <= {shift_reg[8:1], shift_reg[0]};  // update result
                end
            end
            0: begin
                res_valid <= 0;
            end
        endcase
    end
end

endmodule