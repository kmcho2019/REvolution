module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [2:0] x_seq;
reg y_seen;

always @ (posedge clk) begin
    if (!resetn) begin
        state = 2'b00;
        x_seq = 3'b000;
        y_seen = 1'b0;
        f = 1'b0;
        g = 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (resetn) begin
                    state = 2'b01; // Transition to State B
                    f = 1'b1;
                end
            end
            2'b01: begin // State B
                state = 2'b10; // Transition to State C
                f = 1'b0;
            end
            2'b10: begin // State C
                x_seq = {x_seq[1:0], x};
                if (x_seq == 3'b101) begin
                    state = 2'b11; // Transition to State D
                    g = 1'b1;
                    x_seq = 3'b000;
                end
            end
            2'b11: begin // State D
                if (y) begin
                    y_seen = 1'b1;
                end
                if (y_seen) begin
                    // Stay in State D
                end else if (x_seq == 3'b001) begin
                    g = 1'b0;
                    // Stay in State D
                end
            end
        endcase
    end
end

endmodule