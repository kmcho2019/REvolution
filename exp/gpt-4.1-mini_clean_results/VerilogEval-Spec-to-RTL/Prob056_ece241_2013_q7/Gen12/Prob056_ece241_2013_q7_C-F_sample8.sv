module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_Q;

assign next_Q = ( {j,k} )  // Case statement alternative using ternary operators for clarity
               == 2'b00 ? Q       : // Hold state
               ( {j,k} == 2'b01 ) ? 1'b0  : // Reset
               ( {j,k} == 2'b10 ) ? 1'b1  : // Set
                                    ~Q;      // Toggle for 2'b11

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule