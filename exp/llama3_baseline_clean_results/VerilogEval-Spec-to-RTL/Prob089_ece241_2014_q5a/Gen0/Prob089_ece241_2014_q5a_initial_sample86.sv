module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 2 states: complementing (0) and adding (1)
reg started;     // flag to track whether conversion has started

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to complementing state
        started <= 0; // reset conversion flag
        z <= 0; // reset output
    end else if (!started) begin
        if (x) begin
            state <= 1; // transition to adding state
            started <= 1; // set conversion flag
            z <= 1; // assert output
        end else begin
            state <= 0; // stay in complementing state
            started <= 1; // set conversion flag
            z <= ~x; // complement input
        end
    end else begin
        case (state)
            0: begin
                if (x) begin
                    state <= 1; // transition to adding state
                    z <= 1; // assert output
                end else begin
                    z <= ~x; // complement input
                end
            end
            1: begin
                z <= 1; // keep output asserted
            end
        endcase
    end
end

endmodule