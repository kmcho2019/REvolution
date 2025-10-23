module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] x_seq;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 2'b00;
        x_seq <= 0;
        y_count <= 0;
    end else begin
        case (state)
            2'b00: begin
                state <= 2'b01;
                x_seq <= 0;
                y_count <= 0;
            end
            2'b01: begin
                state <= 2'b10;
            end
            2'b10: begin
                if (x) begin
                    x_seq <= x_seq + 1;
                    if (x_seq == 2'b10) begin
                        state <= 2'b11;
                        x_seq <= 0;
                        y_count <= 0;
                    end
                end else if (x_seq == 2'b01) begin
                    x_seq <= 0;
                end else if (x == 1'b0) begin
                    x_seq <= 0;
                end
            end
            2'b11: begin
                if (g == 0) begin
                    g <= 1;
                end
                if (y) begin
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        g <= 0;
                    end
                end
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        2'b00: f = 0;
        2'b01: f = 1;
        default: f = 0;
    endcase
end

endmodule