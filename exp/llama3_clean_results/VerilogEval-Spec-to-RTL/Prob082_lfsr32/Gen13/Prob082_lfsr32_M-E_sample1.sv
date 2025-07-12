module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [7:0] segment0;
reg [7:0] segment1;
reg [7:0] segment2;
reg [7:0] segment3;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate next state of segment 0
        segment0 <= {segment0[0] ^ segment3[7] ^ segment2[7] ^ segment0[1], segment0[7:1]};
        
        // Calculate next state of segment 1
        segment1 <= {segment0[0], segment1[7:1]};
        
        // Calculate next state of segment 2
        segment2 <= {segment1[0], segment2[7:1]};
        
        // Calculate next state of segment 3
        segment3 <= {segment2[0], segment3[7:1]};
        
        // Update output q
        q <= {segment3, segment2, segment1, segment0};
    end
end

endmodule