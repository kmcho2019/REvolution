module JC_counter (
    input  clk,
    input  rst_n,
    output [63:0] Q
);

reg [63:0] Q_reg; // internal 64-bit register

// asynchronous reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // reset condition: set Q to 0
        Q_reg <= 64'd0;
    end else begin
        // update Q based on its current value
        if (Q_reg[0] == 0) begin
            // Q[0] is 0: increment by shifting right and appending 1
            Q_reg <= {1'b1, Q_reg[63:1]};
        end else begin
            // Q[0] is 1: decrement by shifting right and appending 0
            Q_reg <= {1'b0, Q_reg[63:1]};
        end
    end
end

// continuous assignment: assign Q_reg to output Q
assign Q = Q_reg;

endmodule