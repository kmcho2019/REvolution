```thought
To implement the radix-2 divider, we can use a combination of sequential and combinational logic. The sequential logic will handle the control flow, including the division process and the result validity, while the combinational logic will perform the subtraction and update the shift register. We will also use a multiplexer to select the appropriate result based on the carry-out. The design will be implemented using a finite state machine (FSM) to manage the control flow.
```

```verilog
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

reg [15:0] SR;  // Shift Register
reg [7:0] NEG_DIVISOR;  // Negated absolute value of divisor
reg [3:0] cnt;  // Counter
reg start_cnt;  // Flag to indicate start of division
reg [7:0] abs_dividend;  // Absolute value of dividend
reg [7:0] abs_divisor;  // Absolute value of divisor

// Initialize inputs and outputs
always @(*) begin
    if (rst) begin
        SR = 0;
        NEG_DIVISOR = 0;
        cnt = 0;
        start_cnt = 0;
        res_valid = 0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize shift register
        abs_dividend = sign ? (dividend[7] ? ~dividend + 1 : dividend) : dividend;
        abs_divisor = sign ? (divisor[7] ? ~divisor + 1 : divisor) : divisor;
        SR = {abs_dividend, 1'b0};
        NEG_DIVISOR = ~abs_divisor + 1;
        cnt = 1;
        start_cnt = 1;
    end
end

// Perform division
always @ (posedge clk) begin
    if (rst) begin
        SR = 0;
        NEG_DIVISOR = 0;
        cnt = 0;
        start_cnt = 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, update result
            result = {SR[15:8], SR[7:0]};
            res_valid = 1;
            start_cnt = 0;
        end else begin
            // Update shift register
            reg [8:0] sub_result;
            sub_result = SR - abs_divisor;
            if (sub_result[8]) begin
                // Carry-out is 1, subtract and shift right
                SR = {1'b0, SR[15:1]};
            end else begin
                // Carry-out is 0, add and shift left
                SR = {1'b1, SR[15:1]};
            end
            cnt = cnt + 1;
        end
    end
end

// Manage result validity
always @ (posedge clk) begin
    if (rst) begin
        res_valid = 0;
    end else if (res_valid && !opn_valid) begin
        // Result consumed, clear validity flag
        res_valid = 0;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
