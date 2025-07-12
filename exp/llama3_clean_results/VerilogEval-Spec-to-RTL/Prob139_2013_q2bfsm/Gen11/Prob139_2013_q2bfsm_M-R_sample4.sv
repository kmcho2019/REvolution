module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
reg [1:0] x_seq;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 3'b000;
        x_seq <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            3'b000: begin
                state <= 3'b001;
                f <= 1;
                x_seq <= 0;
                y_count <= 0;
            end
            3'b001: begin
                state <= 3'b010;
                f <= 0;
            end
            3'b010: begin
                if (x == 1'b1 && x_seq == 2'b00) begin
                    x_seq <= x_seq + 1;
                end else if (x == 1'b0 && x_seq == 2'b01) begin
                    x_seq <= x_seq + 1;
                end else if (x == 1'b1 && x_seq == 2'b10) begin
                    x_seq <= 0;
                    state <= 3'b100;
                end else begin
                    x_seq <= 0;
                end
            end
            3'b100: begin
                g <= 1;
                if (y == 1'b1 || y_count == 2'b10) begin
                    state <= 3'b101;
                end else begin
                    y_count <= y_count + 1;
                end
            end
            3'b101: begin
                g <= 1;
            end
        endcase
    end
end

endmodule