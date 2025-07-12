module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] q_reg;

    wire [3:0] digits [3:0];
    assign digits[0] = q_reg[3:0];    // ones
    assign digits[1] = q_reg[7:4];    // tens
    assign digits[2] = q_reg[11:8];   // hundreds
    assign digits[3] = q_reg[15:12];  // thousands

    // Enable signals indicate when lower digit(s) are at 9, so next digit should increment
    assign ena[0] = (digits[0] == 4'd9);
    assign ena[1] = ena[0] && (digits[1] == 4'd9);
    assign ena[2] = ena[1] && (digits[2] == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            q_reg <= 16'd0;
        end else begin
            reg [15:0] next_q;
            reg carry;
            integer i;
            next_q = q_reg;
            carry = 1'b1; // start increment by 1

            // Process each digit starting from ones (LSB)
            for (i = 0; i < 4; i = i +1) begin
                if (carry) begin
                    if (next_q[i*4 +:4] == 4'd9) begin
                        // rollover digit and carry to next
                        next_q[i*4 +:4] = 4'd0;
                        carry = 1'b1;
                    end else begin
                        // increment digit, no carry
                        next_q[i*4 +:4] = next_q[i*4 +:4] + 4'd1;
                        carry = 1'b0;
                    end
                end
            end

            q_reg <= next_q;
        end
    end

    assign q = q_reg;

endmodule