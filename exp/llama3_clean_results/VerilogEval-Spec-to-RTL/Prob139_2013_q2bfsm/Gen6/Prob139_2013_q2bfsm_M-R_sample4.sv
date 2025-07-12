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

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_counter <= 0;
        y_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin
                if (x_counter == 3) begin
                    state <= 1;
                    f <= 1;
                    x_counter <= 0;
                end else if (x) begin
                    x_counter <= x_counter + 1;
                end else begin
                    x_counter <= 0;
                end
            end
            1: begin
                state <= 2;
                f <= 0;
            end
            2: begin
                if (y) begin
                    g <= 1;
                    state <= 3;
                end else if (y_counter < 2) begin
                    y_counter <= y_counter + 1;
                end else begin
                    g <= 0;
                    state <= 0;
                end
            end
            3: begin
                // Stay in state 3 permanently
            end
        endcase
    end
end

endmodule