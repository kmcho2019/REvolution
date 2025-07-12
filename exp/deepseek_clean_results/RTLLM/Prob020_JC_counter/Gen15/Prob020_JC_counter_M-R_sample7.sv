module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Next state wire (combinational logic)
wire [63:0] Q_next = {~Q[0], Q[63:1]};

// Sequential logic with synchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low synchronous reset
    end else begin
        Q <= Q_next;  // Register the next state
    end
end

endmodule