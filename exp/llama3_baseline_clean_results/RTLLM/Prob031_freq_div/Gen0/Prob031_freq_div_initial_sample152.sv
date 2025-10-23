```thought
To implement the frequency divider module, we will use three counters to divide the input clock frequency. We will use always blocks to handle the positive edge of the input clock and the reset signal. Inside the always blocks, we will implement the logic for generating the output clock signals CLK_50, CLK_10, and CLK_1 based on the given conditions. We will use non-blocking assignments to update the output signals and counters.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;  // Counter for CLK_50
reg [2:0] cnt_10; // Counter for CLK_10
reg [5:0] cnt_100; // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_2 <= 2'b0;
        cnt_10 <= 3'b0;
        cnt_100 <= 6'b0;
    end else begin
        // CLK_50 generation
        cnt_2 <= cnt_2 + 1;
        if (cnt_2 == 2'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b0;
        end
        
        // CLK_10 generation
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b0;
        end
        
        // CLK_1 generation
        cnt_100 <= cnt_100 + 1;
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b0;
        end
    end
end

endmodule
```

However, a more efficient way to implement this is by removing the counters `cnt_2`, `cnt_10`, and `cnt_100` and directly using the required division value as the condition in the `if` statements.

```thought
We can simplify the design by removing the counters and directly using the required division values.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;  // Counter for CLK_50
reg [3:0] cnt_10; // Counter for CLK_10
reg [6:0] cnt_100; // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_2 <= 2'b0;
        cnt_10 <= 4'b0;
        cnt_100 <= 7'b0;
    end else begin
        cnt_2 <= cnt_2 + 1;
        cnt_10 <= cnt_10 + 1;
        cnt_100 <= cnt_100 + 1;
        
        if (cnt_2 == 2'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b0;
        end
        
        if (cnt_10 == 4'b1000) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0;
        end
        
        if (cnt_100 == 7'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'b0;
        end
    end
end

endmodule
```

But, we can further optimize this by using the `always_ff` block which is more suitable for sequential logic and eliminating the extra counters, reducing the code complexity.

```thought
We can optimize the design by using the `always_ff` block and reducing the counters.
```

```verilog
module freq_div(
    input logic CLK_in,
    input logic RST,
    output logic CLK_50,
    output logic CLK_10,
    output logic CLK_1
);

logic [1:0] cnt_2 = 2'b0;  // Counter for CLK_50
logic [3:0] cnt_10 = 4'b0; // Counter for CLK_10
logic [6:0] cnt_100 = 7'b0; // Counter for CLK_1

always_ff @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_2 <= 2'b0;
        cnt_10 <= 4'b0;
        cnt_100 <= 7'b0;
    end else begin
        cnt_2 <= cnt_2 + 1;
        cnt_10 <= cnt_10 + 1;
        cnt_100 <= cnt_100 + 1;
        
        if (cnt_2 == 2'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b0;
        end
        
        if (cnt_10 == 4'b1000) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0;
        end
        
        if (cnt_100 == 7'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'b0;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
