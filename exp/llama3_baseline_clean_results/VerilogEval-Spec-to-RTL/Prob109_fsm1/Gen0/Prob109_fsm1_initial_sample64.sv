module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg current_state;
assign out = current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1; // asynchronously reset to state B
    end else begin
        case (current_state)
            0: begin // state A
                if (in == 0) begin
                    current_state <= 1; // transition to state B
                end else begin
                    current_state <= 0; // stay in state A
                end
            end
            1: begin // state B
                if (in == 0) begin
                    current_state <= 0; // transition to state A
                end else begin
                    current_state <= 1; // stay in state B
                end
            end
        endcase
    end
end

initial begin
    current_state = 1; // initialize to state B
end

endmodule