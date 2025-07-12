```thought
To implement the instruction register module, we will first define the module with its input and output ports. We will then use two 8-bit registers (ins_p1 and ins_p2) to store the instructions. The registers will be initialized to zero when the reset signal (rst) is low on the rising edge of the clock (clk). Based on the fetch signal, we will update the registers with the incoming instruction from the data input. Finally, we will derive the output signals (ins, ad1, and ad2) from the stored instructions.
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
    if (~rst) begin
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;
            2'b10: ins_p2 <= data;
            default: ;
        endcase
    end
end

assign ins = ins_p1[7:5];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
