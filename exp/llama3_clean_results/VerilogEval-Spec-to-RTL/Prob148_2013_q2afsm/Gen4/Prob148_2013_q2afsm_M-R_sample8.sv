module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00;  // Reset to state A
    end else begin
        if (state == 2'b00) begin
            if (r[0]) begin
                state <= 2'b01;  // Go to state B
            end else if (r[1]) begin
                state <= 2'b10;  // Go to state C
            end else if (r[2]) begin
                state <= 2'b11;  // Go to state D
            end else begin
                state <= 2'b00;  // Stay in state A
            end
        end else if (state == 2'b01) begin
            if (r[0]) begin
                state <= 2'b01;  // Stay in state B
            end else begin
                state <= 2'b00;  // Go back to state A
            end
        end else if (state == 2'b10) begin
            if (r[1]) begin
                state <= 2'b10;  // Stay in state C
            end else begin
                state <= 2'b00;  // Go back to state A
            end
        end else if (state == 2'b11) begin
            if (r[2]) begin
                state <= 2'b11;  // Stay in state D
            end else begin
                state <= 2'b00;  // Go back to state A
            end
        end
    end
end

assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule