module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Using 1-bit to represent two states: OFF (0) and ON (1)
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 0; // Asynchronous reset to state OFF
    end else begin
        case(state)
            0: begin // State OFF
                if(j) begin
                    state <= 1; // Transition to state ON when j = 1
                end else begin
                    state <= 0; // Stay in state OFF when j = 0
                end
            end
            1: begin // State ON
                if(k) begin
                    state <= 0; // Transition to state OFF when k = 1
                end else begin
                    state <= 1; // Stay in state ON when k = 0
                end
            end
        endcase
    end
end

always @(*) begin
    case(state)
        0: out = 0; // Output out = 0 in state OFF
        1: out = 1; // Output out = 1 in state ON
    endcase
end

endmodule