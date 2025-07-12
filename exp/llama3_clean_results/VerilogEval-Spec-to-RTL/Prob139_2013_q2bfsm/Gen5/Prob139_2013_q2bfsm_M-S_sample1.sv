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
reg set_f;
reg wait_y;

always @ (posedge clk) begin
    if (!resetn) begin
        x_seq <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
        set_f <= 1'b0;
        wait_y <= 1'b0;
    end else begin
        if (set_f) begin
            f <= 1;
            set_f <= 1'b0;
            wait_y <= 1'b1;
        end else begin
            f <= 0;
        end
        
        if (wait_y) begin
            if (y) begin
                g <= 1;
                wait_y <= 1'b0;
                y_count <= 0;
            end else if (y_count < 2) begin
                y_count <= y_count + 1;
            end else begin
                g <= 0;
                wait_y <= 1'b0;
            end
        end else begin
            case (x_seq)
                0: if (x) x_seq <= 1;
                1: if (!x) x_seq <= 2; else x_seq <= 1;
                2: if (x) begin
                    x_seq <= 0;
                    set_f <= 1'b1;
                end else x_seq <= 0;
            endcase
        end
    end
end

endmodule