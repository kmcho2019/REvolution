module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg seq_detected;
reg [1:0] seq_state;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        seq_state <= 0;
        seq_detected <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (seq_state)
            0: begin
                if (x) seq_state <= 1;
            end
            1: begin
                if (!x) seq_state <= 2;
                else seq_state <= 1;
            end
            2: begin
                if (x) seq_detected <= 1;
                else seq_state <= 0;
            end
            default: begin
                seq_state <= 0;
            end
        endcase

        if (seq_detected) begin
            f <= 1;
            seq_detected <= 0;
            seq_state <= 0;
            y_count <= 0;
        end else if (f) begin
            f <= 0;
            if (!g) begin
                if (y) begin
                    g <= 1;
                end else if (y_count < 2) begin
                    y_count <= y_count + 1;
                end else begin
                    g <= 0;
                end
            end
        end
    end
end

endmodule