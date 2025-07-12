module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

reg [1:0] current_state;
always @(posedge clk) begin
    case (current_state)
        1'b0: begin
            if (!a) begin
                state <= b;
                current_state <= b;
            end else if (a && b) begin
                state <= 1'b1;
                current_state <= 1'b1;
            end else begin
                state <= 1'b0;
                current_state <= 1'b0;
            end
        end
        1'b1: begin
            if (!a) begin
                state <= b;
                current_state <= b;
            end else if (a && b) begin
                state <= 1'b0;
                current_state <= 1'b0;
            end else begin
                state <= 1'b1;
                current_state <= 1'b1;
            end
        end
    endcase
end

assign q = (a) ? ~b : b;

initial begin
    current_state = 1'b0;
    state = 1'b0;
end

endmodule