module x_sequence_detector(
    input clk,
    input resetn,
    input x,
    output reg seq_detected
);
    reg [2:0] seq_state;
    always @ (posedge clk) begin
        if (!resetn) begin
            seq_state <= 0;
            seq_detected <= 0;
        end else begin
            case (seq_state)
                0: if (x) seq_state <= 1;
                1: if (!x) seq_state <= 2; else seq_state <= 1;
                2: if (x) begin
                    seq_detected <= 1;
                    seq_state <= 0;
                end else seq_state <= 1;
            endcase
        end
    end
endmodule

module HybridFSM(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    reg [1:0] fsm_state;
    reg [1:0] y_count;
    wire x_seq_detected;
    x_sequence_detector seq_det(
        .clk(clk),
        .resetn(resetn),
        .x(x),
        .seq_detected(x_seq_detected)
    );
    always @ (posedge clk) begin
        if (!resetn) begin
            fsm_state <= 0;
            f <= 0;
            g <= 0;
            y_count <= 0;
        end else begin
            case (fsm_state)
                0: begin
                    if (x_seq_detected) begin
                        f <= 1;
                        fsm_state <= 1;
                    end
                end
                1: begin
                    f <= 0;
                    if (y) begin
                        g <= 1;
                        fsm_state <= 2;
                    end else if (y_count == 2) begin
                        fsm_state <= 3;
                    end else begin
                        y_count <= y_count + 1;
                    end
                end
                2: begin
                    // Permanent state, g remains 1
                end
                3: begin
                    // Permanent state, g remains 0
                end
            endcase
        end
    end
endmodule