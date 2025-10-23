module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // State register
reg [1:0] x_count; // Counter for x sequence
reg [1:0] y_count; // Counter for y timing

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 0; // Reset state to A
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case(state)
            0: begin // State A
                if (resetn) begin
                    state <= 1; // Move to State B
                end
                f <= 0;
                g <= 0;
            end
            1: begin // State B
                f <= 1;
                state <= 2; // Move to State C
            end
            2: begin // State C
                f <= 0;
                if (x_count == 0 && x) begin
                    x_count <= 1;
                end else if (x_count == 1 && ~x) begin
                    x_count <= 2;
                end else if (x_count == 2 && x) begin
                    x_count <= 0;
                    state <= 3; // Move to State D
                end else begin
                    x_count <= 0;
                end
            end
            3: begin // State D
                g <= 1;
                y_count <= y_count + 1;
                if (y || y_count == 2) begin
                    if (y) begin
                        state <= 4; // Move to State E
                    end else begin
                        state <= 5; // Move to State F
                    end
                end
            end
            4: begin // State E
                g <= 1;
            end
            5: begin // State F
                g <= 0;
            end
            default: state <= 0;
        endcase
    end
end

endmodule