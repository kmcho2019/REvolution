module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Two states: 0 for A and 1 for B
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        1'b0: begin // State A
            if (~in) begin
                next_state = 1; // A -> B on 0
            end else begin
                next_state = 0; // A -> A on 1
            end
        end
        1'b1: begin // State B
            if (~in) begin
                next_state = 0; // B -> A on 0
            end else begin
                next_state = 1; // B -> B on 1
            end
        end
    endcase
end

always @(*) begin
    case(state)
        1'b0: begin // State A
            out = 0;
        end
        1'b1: begin // State B
            out = 1;
        end
    endcase
end

endmodule