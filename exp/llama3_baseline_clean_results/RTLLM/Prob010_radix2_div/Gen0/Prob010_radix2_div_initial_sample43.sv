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

reg [15:0] sr; // shift register
reg [7:0] neg_divisor; // negated absolute value of divisor
reg [2:0] cnt; // counter
reg start_cnt; // start counter flag
reg [7:0] dividend_reg; // registered dividend
reg [7:0] divisor_reg; // registered divisor

// initialize registers
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        // save inputs
        dividend_reg <= sign? {{8{dividend[7]}}, dividend[7:0]} : dividend;
        divisor_reg <= sign? {{8{divisor[7]}}, divisor[7:0]} : divisor;
        
        // initialize shift register
        sr <= {1'b0, dividend_reg[7:0]};
        
        // set NEG_DIVISOR
        neg_divisor <= ~divisor_reg + 1;
        
        // set counter and start_cnt
        cnt <= 1;
        start_cnt <= 1;
    end
end

// division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            // division complete
            cnt <= 0;
            start_cnt <= 0;
            res_valid <= 1;
        end else begin
            // compute subtraction
            reg [8:0] sub;
            sub <= sr[7:0] - neg_divisor;
            
            // update shift register
            if (sub[8]) begin
                sr <= {1'b1, sr[7:1]};
            end else begin
                sr <= {1'b0, sr[7:1]};
            end
            
            // increment counter
            cnt <= cnt + 1;
        end
    end
end

// manage result validity
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (res_valid &&!opn_valid) begin
        res_valid <= 0;
    end
end

// assign result
assign result = {sr[15:8], sr[7:0]};

endmodule