module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

// Combinational logic to determine the output signals
assign fr2 = (~s[2] && ~s[1] && ~s[0]) ? 1'b1 : 
             (~s[2] && ~s[1] &&  s[0]) ? 1'b0 : 
             (~s[2] &&  s[1] &&  s[0]) ? 1'b0 : 
             (~s[2] &&  s[1] && ~s[0]) ? 1'b0 : 
             ( s[2] &&  s[1] &&  s[0]) ? 1'b0 : 1'b0;

assign fr1 = (~s[2] && ~s[1] && ~s[0]) ? 1'b1 : 
             (~s[2] && ~s[1] &&  s[0]) ? 1'b1 : 
             (~s[2] &&  s[1] &&  s[0]) ? 1'b1 : 
             (~s[2] &&  s[1] && ~s[0]) ? 1'b0 : 
             ( s[2] &&  s[1] &&  s[0]) ? 1'b0 : 1'b0;

assign fr0 = (~s[2] && ~s[1] && ~s[0]) ? 1'b1 : 
             (~s[2] && ~s[1] &&  s[0]) ? 1'b1 : 
             (~s[2] &&  s[1] &&  s[0]) ? 1'b1 : 
             (~s[2] &&  s[1] && ~s[0]) ? 1'b1 : 
             ( s[2] &&  s[1] &&  s[0]) ? 1'b0 : 1'b0;

// Sequential logic to track the previous sensor state and determine 'dfr'
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
        
        // Determine 'dfr' based on the change in sensor state
        if (s > prev_s) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule