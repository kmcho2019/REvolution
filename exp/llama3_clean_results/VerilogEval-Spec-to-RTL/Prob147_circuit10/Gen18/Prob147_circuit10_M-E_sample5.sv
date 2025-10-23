module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

enum logic [0:0] {S0, S1} current_state, next_state;

always @(posedge clk) begin
    current_state <= next_state;
end

always @(current_state, a, b) begin
    case (current_state)
        S0: begin
            if (~a && b) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (a && b) begin
                next_state = S0;
            end else if (~a && ~b) begin
                next_state = S1;
            end else if (a && ~b) begin
                next_state = S1;
            end else if (~a && b) begin
                next_state = S1;
            end
        end
        default: next_state = S0;
    endcase
end

assign q = (current_state == S1) || (a && ~b);
assign state = (current_state == S1);

endmodule