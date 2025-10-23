```thought
To implement the instruction register module, we will first define the two internal registers ins_p1 and ins_p2 to hold the instructions. The rising edge of the clock (clk) will be used to capture the new instruction values into these registers based on the fetch control signal. The reset signal (rst) will be used to initialize the registers to zero when it is low. We will use a case statement within an always block to determine which register to update based on the fetch signal. The outputs ins, ad1, and ad2 will be derived from the values stored in ins_p1 and ins_p2, with ins being the high 3 bits of ins_p1, ad1 being the low 5 bits of ins_p1, and ad2 being the full 8 bits of ins_p2.
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

This code defines the `instr_reg` module with the specified inputs and outputs, and implements the behavior described in the problem statement. The `always` block captures the instruction on the rising edge of `clk` or when `rst` goes low, and the `case` statement determines which register to update based on the `fetch` signal. The outputs are derived from the stored instruction values as specified.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
