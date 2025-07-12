module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Combinational logic to calculate the next state
wire [31:0] q_next;

assign q_next = {q[30:0], q[31] ^ q[21] ^ q[1] ^ q[0]};

// Sequential logic to update the state
always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        q <= q_next;
    end
end

endmodule