module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
reg x_seq_detected;

// FSM
always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        f <= 0;
        g <= 0;
        x_seq_detected <= 0;
    end else begin
        case (state)
            0: begin
                state <= 1;
                f <= 1;
            end
            1: begin
                f <= 0;
                if (x) begin
                    state <= 2;
                end
            end
            2: begin
                if (!x) begin
                    state <= 3;
                end
            end
            3: begin
                if (x) begin
                    state <= 4;
                    x_seq_detected <= 1;
                end else begin
                    state <= 1;
                end
            end
            4: begin
                if (y) begin
                    state <= 5;
                    g <= 1;
                end else if (x_seq_detected) begin
                    g <= 1;
                    state <= 5;
                end else begin
                    state <= 6;
                    g <= 0;
                end
            end
            5: begin
                // No action
            end
            6: begin
                // No action
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

endmodule