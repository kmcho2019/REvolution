```thought
To implement the TopModule with the specified interface, we need to define a module with no input ports and one output port named 'zero'. The output 'zero' should always be LOW (0). This can be achieved by simply assigning the value 0 to the output port 'zero' within the module definition.
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
