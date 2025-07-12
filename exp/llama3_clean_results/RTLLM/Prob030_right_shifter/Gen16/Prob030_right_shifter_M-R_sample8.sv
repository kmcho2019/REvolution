module right_shifter(
    input clk,  // Clock signal
    input rst_n,  // Reset signal (active low)
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Combinational logic block to compute the next state of q
wire [7:0] next_q;
assign next_q = {d, q[7:1]};

// Always block to update the state of q
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q <= 8'd0;  // Reset q to 0 on active low reset
    end else begin
        q <= next_q;  // Update q with the computed next state
    end
end

endmodule