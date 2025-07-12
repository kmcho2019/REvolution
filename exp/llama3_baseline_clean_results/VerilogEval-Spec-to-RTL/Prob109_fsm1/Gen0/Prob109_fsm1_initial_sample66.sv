module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using 1-bit to represent two states
parameter A = 0, B = 1;

always @(*) begin
    if (areset) begin // Asynchronous reset
        state = B;
    end
end

always @(posedge clk) begin
    if (areset) begin // Synchronous reset (not needed if async reset correctly implemented)
        state = B;
    end else begin
        case (state)
            A: begin
                if (~in) begin
                    state = B;
                end
            end
            B: begin
                if (in) begin
                    // Stay in state B
                end else begin
                    state = A;
                end
            end
        endcase
    end
end

always @(state) begin
    case (state)
        A: out = 0;
        B: out = 1;
    endcase
end

endmodule