```thought
To implement the TopModule with the specified interface, we can create a simple module with a single output port named 'zero'. Since the module should always output a LOW, we can directly assign the output 'zero' to 0 in the module's definition.
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
