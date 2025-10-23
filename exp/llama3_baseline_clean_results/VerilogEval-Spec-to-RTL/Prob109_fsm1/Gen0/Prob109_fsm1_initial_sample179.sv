module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // 0 for A, 1 for B

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // asynchronously reset to B (1)
    end else begin
        case (state)
            1'b0: // state A
                if (~in) state <= 1'b1; // A (0) --0--> B
                else state <= 1'b0; // A (0) --1--> A
            1'b1: // state B
                if (in) state <= 1'b1; // B (1) --1--> B
                else state <= 1'b0; // B (1) --0--> A
        endcase
    end
end

// Moore machine output is a function of the current state
assign out = state;

endmodule