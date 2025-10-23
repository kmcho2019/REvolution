module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;

    always @(posedge clk) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
            
            // Output logic based on current sensor values
            fr0 <= ~s[2];  // On unless above s[2] (s[2]=1)
            fr1 <= ~(s[1] | s[2]);  // On when below s[1] (s[1]=0 and s[2]=0)
            fr2 <= ~(s[0] | s[1] | s[2]);  // On only when below s[0] (all sensors=0)
            
            // Detect rising water level (any sensor newly asserted)
            dfr <= (s & ~prev_s) != 3'b000;
        end
    end

endmodule