```thought
To implement the TopModule, we will create a simple module with a single output port named 'zero'. Since the module should always output a LOW, we can directly assign the value 0 to the output port.
```
```verilog
module TopModule(
    output zero
);

assign zero = 1'b0;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
