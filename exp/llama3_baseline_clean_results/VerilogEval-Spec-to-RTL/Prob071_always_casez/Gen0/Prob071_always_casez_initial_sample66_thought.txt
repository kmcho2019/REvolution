```thought
To solve this problem, we will use a priority encoder design approach. We will check each bit of the input vector from least significant to most significant, and as soon as we find a bit that is high (1), we will output the corresponding position. If no bit is high, we will output 0. This can be achieved using a series of if-else statements or a case statement in Verilog. However, a more efficient way is to use a loop to iterate through the bits and break as soon as a high bit is found.
```

```verilog
module TopModule(
    input [7:0] in,
    output [2:0] pos
);

    always @(in) begin
        pos = 3'd0; // Initialize pos to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin // Check if current bit is high
                pos = i; // If high, set pos to current index and break
                break;
            end
        end
    end

endmodule
```

Note: The code above uses a for loop to iterate through each bit of the input vector. The `in[i]` syntax is used to access the `i-th` bit of the input vector. As soon as a high bit is found, the position is set and the loop is terminated using the `break` statement. If no high bit is found after checking all bits, `pos` remains at its initial value of 0.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
