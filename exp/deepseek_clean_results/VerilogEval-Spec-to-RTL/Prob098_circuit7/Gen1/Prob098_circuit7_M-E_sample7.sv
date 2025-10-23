module TopModule (
    input clk,
    input a,
    output reg q
);

reg [1:0] state;

always @(posedge clk) begin
    // Shift in new a value
    state <= {state[0], a};
    
    // Update output based on state
    case (state)
        2'b00: q <= 1'b1;
        2'b11: q <= 1'b0;
        default: q <= q; // maintain current state
    endcase
end

endmodule