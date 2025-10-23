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
reg [1:0] count;

always @ (posedge clk) begin
    if (!resetn) begin
        state = 2'b00;
        x_seq = 3'b000;
        count = 2'b00;
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
                    count = 2'b00;
                end
            end
            2'b11: begin // State D
                if (y) begin
                    count = 2'b00; // Reset count if y is high
                end else begin
                    count = count + 1; // Increment count if y is low
                end
                if (count == 2'b10 &&!y) begin
                    g = 1'b0; // Set g to 0 permanently if y is still low after 2 clock cycles
                end
            end
        endcase
    end
end

endmodule