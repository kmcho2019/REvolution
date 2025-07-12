module TopModule (
    // Select signal
    input        sel,
    // 8-bit input 'a'
    input  [7:0] a,
    // 8-bit input 'b'
    input  [7:0] b,
    // 8-bit output
    output reg [7:0] out
);

    // Always block to handle the selection
    always @(*) begin
        // Ternary operator to select between 'a' and 'b' based on 'sel'
        out = sel ? b : a; // Select 'b' if 'sel' is high, otherwise select 'a'
    end

endmodule