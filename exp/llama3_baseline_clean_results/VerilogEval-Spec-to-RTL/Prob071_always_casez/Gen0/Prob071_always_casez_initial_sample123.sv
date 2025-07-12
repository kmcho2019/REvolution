```thought
To solve this problem, I will create a priority encoder that iterates through the input bits from least significant to most significant. As soon as it encounters a '1' bit, it will output the corresponding index (0-indexed) as a 3-bit value. If no '1' bits are found, it will output 0. This can be achieved using a simple iterative logic with a conditional statement to check for the first '1' bit encountered.
```
```verilog
module TopModule(
    input [7:0] in,  // 8-bit input
    output [2:0] pos  // 3-bit output
);

    integer i;

    always @(*) begin
        pos = 3'd0;  // Initialize output to 0
        for (i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin  // Check if current bit is '1'
                pos = i;  // Output the index of the first '1' bit
                break;  // Exit the loop
            end
        end
    end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
