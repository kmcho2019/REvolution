module LFSR(
    input clk, 
    input rst, 
    output [3:0] out
);

reg [3:0] state; // internal state of the LFSR
assign out = state; // assign internal state to output

always @(posedge clk) begin
    if (rst) begin // check for reset
        state <= 4'b0; // reset to zero
    end else begin
        // calculate feedback
        reg feedback;
        feedback = ~(state[3] ^ state[2]);
        
        // shift and insert feedback
        state <= {state[2:0], feedback};
    end
end

endmodule