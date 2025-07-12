module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] shifted_value = 
    load ? data :  // Highest priority - load overrides everything
    ~ena ? q :     // Next priority - no shift if not enabled
    amount[1] ?    // Right shift if amount[1] is set
        (amount[0] ? {{8{q[63]}}, q[63:8]} :  // Right by 8
                     {q[63], q[63:1]}        // Right by 1
    :              // Otherwise left shift
        (amount[0] ? {q[55:0], 8'b0} :       // Left by 8
                     {q[62:0], 1'b0});       // Left by 1

always @(posedge clk) begin
    q <= shifted_value;
end

endmodule