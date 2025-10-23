```thought
To solve this problem, we will use a priority encoder design approach. The idea is to iterate through the input bits from least significant to most significant and output the position of the first bit that is high. If no bit is high, the output should be zero. We can achieve this using a simple Verilog module that iterates through the input bits and assigns the position to the output as soon as it encounters a high bit.
```

```verilog
module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 3'd0;
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                pos = i;
                break;
            end
        end
    end

endmodule
```

In this code, the `always @(*)` block is used to continuously monitor the input and update the output accordingly. The `for` loop iterates through each bit of the input, and as soon as it encounters a high bit, it assigns the current position to the output `pos` and breaks out of the loop. If no high bit is found after iterating through all bits, the output remains at its default value of zero.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
