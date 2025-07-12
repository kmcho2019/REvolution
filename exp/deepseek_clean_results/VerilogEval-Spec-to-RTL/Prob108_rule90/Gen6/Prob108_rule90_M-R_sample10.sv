module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    
    // Combinational logic for Rule 90
    always @(*) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            next_q[i] = (i == 0 ? 1'b0 : q[i-1]) ^ (i == 511 ? 1'b0 : q[i+1]);
        end
    end
    
    // Synchronous update
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule