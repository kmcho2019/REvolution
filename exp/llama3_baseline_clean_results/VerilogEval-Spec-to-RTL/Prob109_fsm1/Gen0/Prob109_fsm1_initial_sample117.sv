module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] current_state; // Using reg to hold the state value
parameter A = 1'b0;
parameter B = 1'b1;

always @(*) begin
    if (areset) begin
        current_state = B;
    end else begin
        case (current_state)
            A: begin
                if (in) begin
                    current_state = A;
                end else begin
                    current_state = B;
                end
            end
            B: begin
                if (in) begin
                    current_state = B;
                end else begin
                    current_state = A;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    out <= current_state;
end

endmodule