module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state; // 3-bit binary encoding for the states
reg [1:0] x_sequence; // counter for x input sequence
reg [1:0] y_timeout; // counter for y input timeout

always @(posedge clk) begin
    if (~resetn) begin
        state <= 3'b000; // State A
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_timeout <= 0;
    end else begin
        case (state)
            3'b000: begin // State A
                if (resetn) begin
                    state <= 3'b001; // State B
                end
            end
            3'b001: begin // State B
                f <= 1;
                state <= 3'b010; // State C
            end
            3'b010: begin // State C
                if (x) begin
                    x_sequence <= x_sequence + 1;
                end else if (x_sequence == 2'b01) begin
                    x_sequence <= 2'b00;
                end
                if (x_sequence == 2'b11) begin
                    state <= 3'b011; // State D
                end
            end
            3'b011: begin // State D
                g <= 1;
                if (y) begin
                    state <= 3'b100; // State E
                end else begin
                    y_timeout <= y_timeout + 1;
                    if (y_timeout == 2'b10) begin
                        state <= 3'b101; // State F
                    end
                end
            end
            3'b100: begin // State E
                g <= 1;
            end
            3'b101: begin // State F
                g <= 0;
            end
            default: begin
                state <= 3'b000; // State A
            end
        endcase
    end
end

assign f = (state == 3'b001)? 1 : 0;

endmodule