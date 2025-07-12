module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // State A = 3'b000, State B = 3'b001, State C = 3'b010, State D = 3'b011, State E = 3'b100, State F = 3'b101
reg [1:0] x_cnt; // counter for x sequence
reg [1:0] y_cnt; // counter for y time

always @(posedge clk) begin
    if (~resetn) begin // reset is asserted
        state <= 3'b000; // stay in state A
        f <= 0;
        g <= 0;
        x_cnt <= 0;
        y_cnt <= 0;
    end else begin
        case (state)
            3'b000: begin // state A
                state <= 3'b001; // move to state B
                f <= 0;
                g <= 0;
                x_cnt <= 0;
                y_cnt <= 0;
            end
            3'b001: begin // state B
                state <= 3'b010; // move to state C
                f <= 1; // set f to 1 for one clock cycle
                g <= 0;
                x_cnt <= 0;
                y_cnt <= 0;
            end
            3'b010: begin // state C
                if (x_cnt == 0 && x == 1) begin
                    x_cnt <= 1;
                end else if (x_cnt == 1 && x == 0) begin
                    x_cnt <= 2;
                end else if (x_cnt == 2 && x == 1) begin
                    state <= 3'b011; // move to state D
                    f <= 0;
                    g <= 1; // set g to 1
                    x_cnt <= 0;
                    y_cnt <= 0;
                end else begin
                    x_cnt <= 0; // reset x_cnt if sequence is not matched
                end
                g <= 0;
            end
            3'b011: begin // state D
                if (y == 1 || y_cnt == 2) begin
                    if (y == 1) begin
                        state <= 3'b100; // move to state E
                    end else begin
                        state <= 3'b101; // move to state F
                    end
                    y_cnt <= 0;
                end else begin
                    y_cnt <= y_cnt + 1; // increment y_cnt
                end
            end
            3'b100: begin // state E
                g <= 1; // maintain g = 1 permanently
            end
            3'b101: begin // state F
                g <= 0; // maintain g = 0 permanently
            end
            default: begin
                state <= 3'b000; // default state
                f <= 0;
                g <= 0;
                x_cnt <= 0;
                y_cnt <= 0;
            end
        endcase
    end
end

endmodule