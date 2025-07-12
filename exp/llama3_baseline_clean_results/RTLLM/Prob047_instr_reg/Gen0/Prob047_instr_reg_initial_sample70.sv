```thought
To design the instr_reg module, we will first declare the input and output ports as specified. Then, we will use always blocks to describe the behavior of the module. We will use one always block to handle the reset condition and another to handle the clock edge condition. Inside these blocks, we will implement the logic to update the internal registers (ins_p1 and ins_p2) based on the fetch signal. Finally, we will use continuous assignment statements to derive the output signals (ins, ad1, and ad2) from the internal registers.
```

```verilog
module instr_reg(
    input clk, 
    input rst, 
    input [1:0] fetch, 
    input [7:0] data, 
    output [2:0] ins, 
    output [4:0] ad1, 
    output [7:0] ad2
);

reg [7:0] ins_p1;
reg [7:0] ins_p2;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;
            2'b10: ins_p2 <= data;
            default: begin
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

assign ins = ins_p1[7:5];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2;

endmodule
```

Note: The code above assumes that the ins output should be derived from the high 3 bits of ins_p1, and the ad1 output should be derived from the low 5 bits of ins_p1. The ad2 output is simply the full 8-bit value of ins_p2. If this is not the intended behavior, the continuous assignment statements can be adjusted accordingly.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
