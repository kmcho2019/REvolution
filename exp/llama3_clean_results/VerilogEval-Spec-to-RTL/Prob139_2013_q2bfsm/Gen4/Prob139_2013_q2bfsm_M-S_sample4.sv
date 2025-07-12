module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_seq;
reg [1:0] y_count;
reg start;

always @ (posedge clk) begin
    if (!resetn) begin
        x_seq <= 0;
        y_count <= 0;
        start <= 1;
        f <= 0;
        g <= 0;
    end else begin
        if (start) begin
            f <= 1;
            start <= 0;
        end else begin
            f <= 0;
        end

        if (x_seq == 3) begin
            if (y_count < 2) begin
                if (y) begin
                    g <= 1;
                    y_count <= 2;
                end else begin
                    y_count <= y_count + 1;
                end
            end else if (y_count == 2) begin
                g <= 0;
            end
        end else begin
            case (x_seq)
                0: if (x) x_seq <= x_seq + 1;
                1: if (!x) x_seq <= x_seq + 1;
                2: if (x) x_seq <= x_seq + 1;
                default: x_seq <= 0;
            endcase
        end
    end
end

endmodule