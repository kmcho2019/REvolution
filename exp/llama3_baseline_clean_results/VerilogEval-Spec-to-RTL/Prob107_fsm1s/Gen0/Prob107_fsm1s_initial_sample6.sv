module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg current_state; // 0: A, 1: B
reg next_state;

always @(*) begin
    case(current_state)
        1'b0: begin // A
            if (!in) begin
                next_state = 1'b1; // B
            end else begin
                next_state = 1'b0; // A
            end
        end
        1'b1: begin // B
            if (!in) begin
                next_state = 1'b0; // A
            end else begin
                next_state = 1'b1; // B
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= 1'b1; // Reset to B
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        1'b0: out = 1'b0; // A
        1'b1: out = 1'b1; // B
    endcase
end

endmodule