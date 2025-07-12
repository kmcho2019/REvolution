module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg f_out;
reg g_out;
reg [1:0] x_sequence;
reg [1:0] y_timer;
reg reset_deasserted;

always @(posedge clk) begin
    if (!resetn) begin
        f_out <= 0;
        g_out <= 0;
        x_sequence <= 0;
        y_timer <= 0;
        reset_deasserted <= 0;
    end else begin
        if (!reset_deasserted) begin
            f_out <= 1;
            reset_deasserted <= 1;
        end else begin
            f_out <= 0;
        end

        case (x_sequence)
            2'b00: begin
                if (x) begin
                    x_sequence <= 2'b01;
                end
            end
            2'b01: begin
                if (!x) begin
                    x_sequence <= 2'b10;
                end else begin
                    x_sequence <= 2'b00;
                end
            end
            2'b10: begin
                if (x) begin
                    x_sequence <= 2'b11;
                end else begin
                    x_sequence <= 2'b00;
                end
            end
            2'b11: begin
                if (!g_out) begin
                    g_out <= 1;
                    y_timer <= 1;
                end
                x_sequence <= 2'b11;
            end
        endcase

        if (g_out && !y) begin
            y_timer <= y_timer + 1;
            if (y_timer > 2) begin
                g_out <= 0;
            end
        end else if (y) begin
            y_timer <= 0;
        end
    end
end

assign f = f_out;
assign g = g_out;

endmodule