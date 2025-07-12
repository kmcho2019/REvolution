module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0: reset, 1: set f, 2: track x sequence, 3: set g, 4: check y, 5: g = 1 permanently, 6: g = 0 permanently
reg [1:0] x_count;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_count <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin
                state <= 1;
                f <= 1;
                x_count <= 0;
                y_count <= 0;
            end
            1: begin
                state <= 2;
                f <= 0;
            end
            2: begin
                if (x_count == 0 && x) begin
                    x_count <= 1;
                end else if (x_count == 1 &&!x) begin
                    x_count <= 2;
                end else if (x_count == 2 && x) begin
                    state <= 3;
                    x_count <= 0;
                end else begin
                    x_count <= 0;
                end
            end
            3: begin
                state <= 4;
                g <= 1;
                y_count <= 0;
            end
            4: begin
                if (y) begin
                    state <= 5;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        state <= 6;
                    end
                end
            end
            5: begin
                // Maintain g as 1 permanently
            end
            6: begin
                g <= 0; // Set g to 0 permanently
            end
        endcase
    end
end

endmodule