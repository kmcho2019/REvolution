```thought
To solve this problem, we'll first create an 8-bit shift register using 8 D-type flip-flops. The shift register will have an input S and will be enabled by the enable signal, which is synchronous and active high. The shift register will be designed such that the MSB (most significant bit) is shifted in first.

Next, we'll extend the circuit to include 3 additional inputs A, B, and C, and an output Z. We'll use multiplexers to select the output of the shift register based on the values of A, B, and C. Since we have 3 inputs, we'll need a 2^3:1 multiplexer (8:1 multiplexer) to select one of the 8 outputs of the shift register. The multiplexer will be controlled by the 3-bit signal ABC, where ABC = 000 selects Q[0], ABC = 001 selects Q[1], and so on.

We'll use Verilog's built-in modules and logic to implement the D-type flip-flops and the multiplexer.
```

```verilog
module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

// Create an 8-bit shift register with 8 D-type flip-flops
reg [7:0] Q;

// Shift register logic
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// Create a 2^3:1 multiplexer (8:1 multiplexer) to select one of the 8 outputs of the shift register
assign Z = (A == 0 && B == 0 && C == 0) ? Q[0] :
           (A == 0 && B == 0 && C == 1) ? Q[1] :
           (A == 0 && B == 1 && C == 0) ? Q[2] :
           (A == 0 && B == 1 && C == 1) ? Q[3] :
           (A == 1 && B == 0 && C == 0) ? Q[4] :
           (A == 1 && B == 0 && C == 1) ? Q[5] :
           (A == 1 && B == 1 && C == 0) ? Q[6] :
           (A == 1 && B == 1 && C == 1) ? Q[7] : 1'bx;

endmodule
```
Note: In the above code, the `always` block is used to describe the shift register logic, which shifts the bits to the right when the `enable` signal is high. The `assign` statement is used to describe the multiplexer logic, which selects one of the 8 outputs of the shift register based on the values of A, B, and C. 

Alternatively, the multiplexer can be implemented using a case statement for better readability:
```verilog
always @(*) begin
    case ({A, B, C})
        3'b000: Z = Q[0];
        3'b001: Z = Q[1];
        3'b010: Z = Q[2];
        3'b011: Z = Q[3];
        3'b100: Z = Q[4];
        3'b101: Z = Q[5];
        3'b110: Z = Q[6];
        3'b111: Z = Q[7];
        default: Z = 1'bx;
    endcase
end
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
