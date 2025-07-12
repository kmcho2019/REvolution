module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] x_counter;
reg [1:0] y_counter;
reg seq_detected;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 2'b00; // State A
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
        seq_detected <= 0;
    end else begin
        case (state)
            2'b00: begin // State A
                f <= 0;
                g <= 0;
                if (resetn) begin
                    state <= 2'b01; // Transition to State B
                    f <= 1;
                end
            end
            2'b01: begin // State B
                f <= 0;
                state <= 2'b10; // Transition to State C
            end
            2'b10: begin // State C
                if (x) begin
                    x_counter <= x_counter + 1;
                    if (x_counter == 3'b001) begin
                        seq_detected <= 1;
                    end else if (x_counter == 3'b010) begin
                        seq_detected <= 0;
                    end else if (x_counter == 3'b011) begin
                        seq_detected <= 1;
                    end else if (x_counter == 3'b100) begin
                        seq_detected <= 0;
                    end else if (x_counter == 3'b101) begin
                        seq_detected <= 1;
                    end else if (x_counter == 3'b110) begin
                        seq_detected <= 0;
                    end else if (x_counter == 3'b111) begin
                        seq_detected <= 0;
                        state <= 2'b11; // Transition to State D
                        g <= 1;
                    end
                end else begin
                    x_counter <= 0;
                    seq_detected <= 0;
                end
            end
            2'b11: begin // State D
                g <= 1;
                y_counter <= y_counter + 1;
                if (y) begin
                    state <= 2'b100; // Transition to State E
                end else if (y_counter == 2) begin
                    state <= 2'b101; // Transition to State F
                    g <= 0;
                end
            end
            2'b100: begin // State E
                g <= 1;
            end
            2'b101: begin // State F
                g <= 0;
            end
        endcase
    end
end

endmodule