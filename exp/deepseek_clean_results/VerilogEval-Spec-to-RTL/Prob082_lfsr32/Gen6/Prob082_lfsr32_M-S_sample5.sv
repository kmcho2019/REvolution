module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= {feedback, 
              q[31:23], 
              q[22] ^ feedback, 
              q[21:3], 
              q[2] ^ feedback, 
              q[1] ^ feedback};
    end
end

endmodule