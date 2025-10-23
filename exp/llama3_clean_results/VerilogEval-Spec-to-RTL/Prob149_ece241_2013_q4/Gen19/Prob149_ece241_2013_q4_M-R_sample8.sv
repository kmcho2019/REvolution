module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Register to store previous sensor state

// Continuous assignments for output signals 'fr2', 'fr1', and 'fr0'
assign fr2 = ~(s[0] | s[1] | s[2]);
assign fr1 = ~(s[0] | s[1]);
assign fr0 = ~s[0];

// Always block to update 'prev_s' and determine 'dfr'
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
        // Determine supplemental flow rate signal (dfr)
        if ((s[0] && !prev_s[0]) || (s[1] && !prev_s[1]) || (s[2] && !prev_s[2])) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule