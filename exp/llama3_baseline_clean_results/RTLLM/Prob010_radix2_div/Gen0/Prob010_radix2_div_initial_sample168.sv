```thought
To implement a simplified radix-2 divider, I will follow these steps:
- Create a module named `radix2_div` with the specified input and output ports.
- Upon receiving a valid operation request (opn_valid high and res_valid low), initialize the internal states with the absolute values of the inputs and the operation type (signed or unsigned).
- Implement a counter to track the division steps.
- Update the shift register based on the subtraction result of the current remainder and the divisor, handling carry-out and shifting.
- Manage the result validity signal (res_valid) based on the reset, counter, and consumption of the result.
- Handle both signed and unsigned division by properly setting up the initial values and processing the final result.

The design will involve combinatorial and sequential logic to handle the different stages of the division process.
```

```verilog
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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [15:0] sr; // Shift register
reg [3:0] cnt; // Counter
reg start_cnt; // Start counter flag
reg [15:0] tmp; // Temporary register for shift and subtraction

always @(*) begin
    if (sign) begin
        abs_dividend = (dividend[7] == 1'b0) ? dividend : ~(~dividend + 1);
        abs_divisor = (divisor[7] == 1'b0) ? divisor : ~(~divisor + 1);
    end else begin
        abs_dividend = dividend;
        abs_divisor = divisor;
    end
    neg_divisor = ~(abs_divisor - 1); // Two's complement
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs and initialize shift register
            sr <= {1'b0, abs_dividend}; // Initialize shift register
            start_cnt <= 1'b1;
            cnt <= 4'd1;
        end else if (start_cnt) begin
            if (cnt == 4'd8) begin
                // Division complete, update result
                result <= {sr[15:8], sr[7:0]};
                res_valid <= 1'b1;
                start_cnt <= 1'b0;
                cnt <= 4'd0;
            end else begin
                // Perform subtraction and update shift register
                tmp = sr - {8'd0, neg_divisor};
                if (tmp[15]) begin // Check carry-out
                    sr <= {1'b1, sr[14:0]};
                end else begin
                    sr <= {1'b0, sr[14:0]} + {8'd0, abs_divisor};
                end
                cnt <= cnt + 1'b1;
            end
        end else if (res_valid && !opn_valid) begin
            // Result has been consumed, reset validity
            res_valid <= 1'b0;
        end
    end
end

endmodule
```

Please note, this design follows the steps outlined in the problem description. It uses a combination of combinatorial and sequential logic to implement the radix-2 divider for 8-bit integers. The use of `always @(*)` and `always @(posedge clk or posedge rst)` blocks allows for the separation of combinatorial logic and sequential logic, enhancing readability and ensuring that the design adheres to synchronous design principles.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
