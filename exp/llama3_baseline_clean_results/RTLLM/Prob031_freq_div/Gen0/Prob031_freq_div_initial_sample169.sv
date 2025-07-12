```thought
The module freq_div will be designed with three counters to generate the desired clock frequencies. 
The counters will be implemented using always blocks, and the output clock signals will be updated based on the conditions specified in the problem. 
The module will have input ports for the input clock signal CLK_in and the reset signal RST, and output ports for the generated clock signals CLK_50, CLK_10, and CLK_1. 
The always blocks will use the posedge of the input clock signal to update the counters and the output clock signals.
```
```verilog
module freq_div(CLK_in, RST, CLK_50, CLK_10, CLK_1);
    input CLK_in;
    input RST;
    output reg CLK_50;
    output reg CLK_10;
    output reg CLK_1;
    reg [1:0] cnt_2;
    reg [2:0] cnt_10;
    reg [5:0] cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if(RST) begin
            CLK_50 <= 0;
            cnt_2 <= 0;
            CLK_10 <= 0;
            cnt_10 <= 0;
            CLK_1 <= 0;
            cnt_100 <= 0;
        end
        else begin
            if(cnt_2 == 1) begin
                CLK_50 <= ~CLK_50;
                cnt_2 <= 0;
            end
            else begin
                cnt_2 <= cnt_2 + 1;
            end

            if(cnt_10 == 4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;
            end
            else begin
                cnt_10 <= cnt_10 + 1;
            end

            if(cnt_100 == 49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 0;
            end
            else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end
endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
