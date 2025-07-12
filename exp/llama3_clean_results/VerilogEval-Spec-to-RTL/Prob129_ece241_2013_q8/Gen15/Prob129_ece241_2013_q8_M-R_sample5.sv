module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

enum logic [1:0] {S0, S1, S2} state, next_state;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (!x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        default: next_state = S0;
    endcase
end

assign z = (state == S2) && x;

endmodule