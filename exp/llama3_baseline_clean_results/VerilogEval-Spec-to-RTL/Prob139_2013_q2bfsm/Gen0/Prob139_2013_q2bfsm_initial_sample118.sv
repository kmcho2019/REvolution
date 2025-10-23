module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // 2-bit state register
reg [1:0] x_counter; // counter for x sequence
reg [1:0] y_counter; // counter for y sequence

always @(posedge clk) begin
    if (~resetn) begin // reset
        state <= 0; // State A
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        case (state)
            0: begin // State A
                f <= 0;
                g <= 0;
                if (resetn) begin
                    state <= 1; // transition to State B
                    f <= 1;
                end
            end
            1: begin // State B
                f <= 0;
                state <= 2; // transition to State C
            end
            2: begin // State C
                if (x) begin
                    x_counter <= x_counter + 1;
                end else begin
                    x_counter <= 0;
                end
                if (x_counter == 3) begin
                    g <= 1;
                    state <= 3; // transition to State D
                    x_counter <= 0;
                end
            end
            3: begin // State D
                if (~y) begin
                    y_counter <= y_counter + 1;
                end else begin
                    y_counter <= 0;
                    g <= 1;
                end
                if (y_counter == 2) begin
                    g <= 0;
                end
            end
        endcase
    end
end

endmodule