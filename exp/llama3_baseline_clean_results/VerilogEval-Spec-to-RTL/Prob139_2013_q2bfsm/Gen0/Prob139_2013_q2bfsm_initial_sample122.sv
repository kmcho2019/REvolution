module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // 0: A, 1: B, 2: C, 3: D, 4: E, 5: F
reg [1:0] x_prev; // x_prev[0] is x at previous clock cycle, x_prev[1] is x at clock cycle before previous
reg [1:0] y_count; // counter for y in state D
reg x_seq_det; // flag to indicate if x sequence is detected

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 0;
        f <= 0;
        g <= 0;
        x_prev <= 0;
        y_count <= 0;
        x_seq_det <= 0;
    end
    else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1; // move to state B after reset de-assertion
                end
                f <= 0;
                g <= 0;
            end
            1: begin // State B
                f <= 1; // set f to 1 for one clock cycle
                state <= 2; // move to state C
            end
            2: begin // State C
                x_prev <= {x_prev[0], x}; // update x_prev
                if (x_prev == 2'b101) begin // check for x sequence 1, 0, 1
                    x_seq_det <= 1;
                    state <= 3; // move to state D
                end
                f <= 0;
                g <= 0;
            end
            3: begin // State D
                g <= 1; // set g to 1
                y_count <= y_count + 1; // increment y counter
                if (y) begin // if y is 1, move to state E
                    state <= 4;
                end
                else if (y_count == 2) begin // if y is not 1 after 2 clock cycles, move to state F
                    state <= 5;
                end
                f <= 0;
            end
            4: begin // State E
                g <= 1; // maintain g at 1
                f <= 0;
            end
            5: begin // State F
                g <= 0; // set g to 0
                f <= 0;
            end
        endcase
    end
end

endmodule