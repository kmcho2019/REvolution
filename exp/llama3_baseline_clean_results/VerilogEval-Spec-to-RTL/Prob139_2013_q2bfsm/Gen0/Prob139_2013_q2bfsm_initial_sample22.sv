module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state;
reg [1:0] seq_count;
reg [1:0] y_count;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 0; // State A
        f <= 0;
        g <= 0;
        seq_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1; // State B
                    f <= 1;
                    g <= 0;
                end else begin
                    state <= 0; // State A
                    f <= 0;
                    g <= 0;
                end
            end
            1: begin // State B
                state <= 2; // State C
                f <= 0;
                g <= 0;
            end
            2: begin // State C
                if (x) begin
                    seq_count <= seq_count + 1;
                    if (seq_count == 1) begin
                        state <= 2; // State C
                    end else if (seq_count == 2 && ~x) begin
                        seq_count <= 0;
                        state <= 2; // State C
                    end else if (seq_count == 3 && x) begin
                        state <= 3; // State D
                    end
                end else begin
                    seq_count <= 0;
                    state <= 2; // State C
                end
            end
            3: begin // State D
                g <= 1;
                if (y) begin
                    state <= 4; // State E
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        state <= 5; // State F
                    end
                end
            end
            4: begin // State E
                g <= 1;
                state <= 4; // State E
            end
            5: begin // State F
                g <= 0;
                state <= 5; // State F
            end
            default: begin
                state <= 0; // State A
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule