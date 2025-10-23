module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg [1:0] state; // state[1]=B, state[0]=A (one-hot)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to state A
        z <= 1'b0;
    end else begin
        case (state)
            2'b01: begin // A
                if (x) begin
                    state <= 2'b10; // go to B
                    z <= 1'b1;
                end else begin
                    state <= 2'b01; // stay A
                    z <= 1'b0;
                end
            end
            2'b10: begin // B
                if (x) begin
                    state <= 2'b10; // stay B
                    z <= 1'b0;
                end else begin
                    state <= 2'b10; // stay B
                    z <= 1'b1;
                end
            end
            default: begin
                state <= 2'b01; // safety reset to A if invalid
                z <= 1'b0;
            end
        endcase
    end
end

endmodule