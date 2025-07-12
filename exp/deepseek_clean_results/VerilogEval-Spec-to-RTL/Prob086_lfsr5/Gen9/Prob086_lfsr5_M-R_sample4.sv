module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

// Combinational logic for next state
assign next_q = {q[0], q[4], q[3] ^ q[0], q[2], q[1]};

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Active high sync reset to 1
    end
    else begin
        q <= next_q;
    end
end

endmodule