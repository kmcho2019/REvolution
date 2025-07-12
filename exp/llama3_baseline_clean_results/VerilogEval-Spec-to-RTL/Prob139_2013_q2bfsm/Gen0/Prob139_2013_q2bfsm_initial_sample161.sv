module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
reg [1:0] x_count;
reg [1:0] y_count;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 0; // State A
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1; // State B
                end
            end
            1: begin // State B
                f <= 1;
                state <= 2; // State C
            end
            2: begin // State C
                f <= 0;
                if (x) begin
                    x_count <= x_count + 1;
                end else begin
                    x_count <= 0;
                end
                if (x_count == 3 && x == 1) begin
                    state <= 3; // State D
                end
            end
            3: begin // State D
                g <= 1;
                y_count <= y_count + 1;
                if (y) begin
                    state <= 4; // State E
                end else if (y_count == 2) begin
                    state <= 5; // State F
                end
            end
            4: begin // State E
                // Maintain g = 1 permanently
            end
            5: begin // State F
                g <= 0;
                // Maintain g = 0 permanently
            end
            default: begin
                state <= 0; // State A
            end
        endcase
    end
end

endmodule