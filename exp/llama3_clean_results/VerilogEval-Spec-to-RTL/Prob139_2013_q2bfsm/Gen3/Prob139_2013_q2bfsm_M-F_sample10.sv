module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // state of the FSM
reg [1:0] x_sequence; // x sequence counter
reg [1:0] y_timer; // y timer
reg reset_deasserted; // flag to indicate reset de-assertion

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0; // state A
        x_sequence <= 0;
        y_timer <= 0;
        reset_deasserted <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (reset_deasserted) begin
                    f <= 1;
                    state <= 1; // transition to state B
                    reset_deasserted <= 0;
                end else if (!reset_deasserted) begin
                    reset_deasserted <= 1;
                end
            end
            1: begin // state B
                f <= 0;
                if (x) begin
                    x_sequence <= 1; // start x sequence detection
                    state <= 2; // transition to state C
                end
            end
            2: begin // state C
                if (x_sequence == 1) begin
                    if (!x) begin
                        x_sequence <= 2; // continue x sequence detection
                    end else begin
                        x_sequence <= 1; // restart x sequence detection
                    end
                end else if (x_sequence == 2) begin
                    if (x) begin
                        state <= 3; // transition to state D
                        x_sequence <= 0; // reset x sequence counter
                    end else begin
                        x_sequence <= 1; // restart x sequence detection
                    end
                end
            end
            3: begin // state D
                if (y_timer < 2) begin
                    if (y) begin
                        g <= 1; // set g to 1 permanently
                        state <= 4; // transition to state E
                    end else begin
                        y_timer <= y_timer + 1; // increment y timer
                    end
                end else begin
                    g <= 0; // set g to 0 permanently
                    state <= 4; // transition to state E
                end
            end
            4: begin // state E
                // maintain g permanently
            end
        endcase
    end
end

endmodule