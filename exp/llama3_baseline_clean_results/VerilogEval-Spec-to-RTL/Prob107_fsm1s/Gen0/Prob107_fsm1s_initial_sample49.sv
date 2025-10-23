module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state;  // 1-bit signal to represent the state

localparam B = 1'b1;  // State B
localparam A = 1'b0;  // State A

always @(posedge clk) begin
    if (reset) begin
        state <= B;
        out <= 1'b1;
    end else begin
        case (state)
            B: begin
                if (~in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
                out <= 1'b1;
            end
            A: begin
                if (~in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
                out <= 1'b0;
            end
        endcase
    end
end

endmodule