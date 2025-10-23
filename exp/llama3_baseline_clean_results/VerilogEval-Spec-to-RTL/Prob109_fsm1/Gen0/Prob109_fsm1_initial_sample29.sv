module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // 0: A, 1: B
reg [0:0] nextState;

always @(posedge clk or negedge areset) begin
    if (~areset) begin // asynchronous reset
        state <= 1; // reset to state B
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        1'b0: begin // state A
            if (in == 1'b1) begin
                nextState = 1'b0; // A with in=1 goes to A
            end else begin
                nextState = 1'b1; // A with in=0 goes to B
            end
        end
        1'b1: begin // state B
            if (in == 1'b1) begin
                nextState = 1'b1; // B with in=1 stays in B
            end else begin
                nextState = 1'b0; // B with in=0 goes to A
            end
        end
        default: nextState = 1'b1; // default to state B
    endcase
end

assign out = state;

endmodule