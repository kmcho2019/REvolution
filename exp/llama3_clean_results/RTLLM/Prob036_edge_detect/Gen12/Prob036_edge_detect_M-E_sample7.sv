module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg [1:0] state;
reg a_prev;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        a_prev <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (a && !a_prev) begin
                    state <= 2'b01;
                    rise <= 1'b1;
                    down <= 1'b0;
                end else if (!a && a_prev) begin
                    state <= 2'b10;
                    rise <= 1'b0;
                    down <= 1'b1;
                end else begin
                    state <= 2'b00;
                    rise <= 1'b0;
                    down <= 1'b0;
                end
                a_prev <= a;
            end
            2'b01: begin
                state <= 2'b00;
                rise <= 1'b0;
                down <= 1'b0;
            end
            2'b10: begin
                state <= 2'b00;
                rise <= 1'b0;
                down <= 1'b0;
            end
            default: begin
                state <= 2'b00;
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

endmodule