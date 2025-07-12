module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Internal signal to hold the shifted value
reg [63:0] shifted_Q;

// Combinational logic to determine the next state
always @(*) begin
    if (Q[0] == 1'b0) begin
        shifted_Q = {1'b1, Q[63:1]};
    end else begin
        shifted_Q = {1'b0, Q[63:1]};
    end
end

// Sequential logic to update the counter value
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'd0;
    end else begin
        Q <= shifted_Q;
    end
end

endmodule