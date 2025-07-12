module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // 0: State A, 1: State B, 2: State C, 3: State D, 4: State E
reg [1:0] x_count; // counter to detect x sequence
reg [1:0] y_count; // counter to detect y sequence

always @(posedge clk) begin
    if (~resetn) begin // reset
        state <= 0; // State A
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1; // transition to State B
                end
            end
            1: begin // State B
                f <= 1;
                state <= 2; // transition to State C
            end
            2: begin // State C
                f <= 0;
                if (x == 1) begin
                    x_count <= 1; // start counting x sequence
                end else if (x_count == 1 && x == 0) begin
                    x_count <= 2;
                end else if (x_count == 2 && x == 1) begin
                    x_count <= 3;
                    state <= 3; // transition to State D
                end else begin
                    x_count <= 0; // reset x sequence counter
                end
            end
            3: begin // State D
                g <= 1;
                state <= 4; // transition to State E
            end
            4: begin // State E
                if (y == 1) begin
                    y_count <= 2; // set y_count to 2 to maintain g = 1
                end else if (y_count == 0) begin
                    y_count <= 1; // start counting y sequence
                end else if (y_count == 1) begin
                    y_count <= 2;
                    if (y_count == 2) begin
                        g <= 0; // set g to 0 permanently
                    end
                end
            end
        endcase
    end
end

endmodule