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
reg [8:0] sr;  // shift register
reg [7:0] neg_divisor;  // negated divisor
reg [2:0] cnt;  // counter
reg start_cnt;  // start counter signal
reg [15:0] result_reg;  // result register

// Multiplexer to select the result based on carry-out
wire [8:0] mux_out;
assign mux_out = (sr[8] == 1)? (sr - {1'b0, neg_divisor}) : ({1'b1, sr} >> 1);

// Subtraction result (carry-out)
wire cout;
assign cout = (sr[8] == 1)? 1'b0 : 1'b1;

// Initialize registers
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 9'd0;
        neg_divisor <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'b0;
        result_reg <= 16'd0;
        res_valid <= 1'b0;
    end else if (opn_valid &&!res_valid) begin
        // Save inputs and initialize registers
        dividend_reg <= (sign == 1)? {{7{dividend[7]}}, dividend[7:0]} : dividend;
        divisor_reg <= (sign == 1)? {{7{divisor[7]}}, divisor[7:0]} : divisor;
        sr <= {1'b0, dividend_reg};
        neg_divisor <= ~divisor_reg + 1'b1;
        cnt <= 1'd1;
        start_cnt <= 1'b1;
    end
end

// Perform division
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8'd8) begin
            // Division complete
            cnt <= 3'd0;
            start_cnt <= 1'b0;
            result_reg <= {sr[8:1], sr[0:0]};
            res_valid <= 1'b1;
        end else begin
            // Update shift register and counter
            sr <= {cout, sr[8:1]};
            cnt <= cnt + 1'd1;
        end
    end
end

// Update result validity
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
    end else if (res_valid &&!opn_valid) begin
        // Result consumed
        res_valid <= 1'b0;
    end
end

assign result = result_reg;

endmodule