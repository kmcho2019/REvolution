module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
reg [1:0] x_seq;
reg [1:0] count;

always @ (posedge clk) begin
    if (!resetn) begin
        state = 3'b000;
        x_seq = 2'b00;
        count = 2'b00;
        f = 1'b0;
        g = 1'b0;
    end else begin
        case (state)
            3'b000: begin // State A
                if (resetn) begin
                    state = 3'b001; // Transition to State B
                    f = 1'b1;
                end
            end
            3'b001: begin // State B
                state = 3'b010; // Transition to State C
                f = 1'b0;
            end
            3'b010: begin // State C
                x_seq = {x_seq[0], x};
                if (x_seq == 2'b01) begin // Detecting '10' in sequence
                    if (x == 1'b1) begin // Checking for the final '1'
                        state = 3'b011; // Transition to State D
                        g = 1'b1;
                        count = 2'b00;
                    end
                end else if (x_seq == 2'b10) begin // Reset sequence detection
                    x_seq = 2'b00;
                end
            end
            3'b011: begin // State D
                count = count + 1;
                if (y) begin
                    state = 3'b100; // Transition to State E
                end else if (count == 2'b10) begin
                    state = 3'b101; // Transition to State F
                    g = 1'b0;
                end
            end
            3'b100: begin // State E
                g = 1'b1;
            end
            3'b101: begin // State F
                g = 1'b0;
            end
        endcase
    end
end

endmodule