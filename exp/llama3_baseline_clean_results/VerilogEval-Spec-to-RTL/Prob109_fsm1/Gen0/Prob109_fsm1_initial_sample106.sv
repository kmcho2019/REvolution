module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // 0: A, 1: B
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset to B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        1'b0: begin // A
            if (in == 1'b0) begin
                next_state = 1; // A -> B
            end else begin
                next_state = 0; // A -> A
            end
            out = 1'b0; // Output for state A
        end
        1'b1: begin // B
            if (in == 1'b0) begin
                next_state = 0; // B -> A
            end else begin
                next_state = 1; // B -> B
            end
            out = 1'b1; // Output for state B
        end
    endcase
end

endmodule