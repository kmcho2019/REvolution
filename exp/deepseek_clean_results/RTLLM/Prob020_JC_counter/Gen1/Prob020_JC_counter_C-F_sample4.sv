module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Pipeline registers for shift operation
reg [63:0] Q_next;
wire terminal_state = &Q || ~|Q; // All 1s or all 0s

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        Q_next <= 64'b0;
    end
    else if (!terminal_state) begin // Clock gating for terminal states
        Q <= Q_next;
        if (Q[0] == 1'b0) begin
            Q_next <= {1'b1, Q[63:1]};
        end
        else begin
            Q_next <= {1'b0, Q[63:1]};
        end
    end
end

endmodule