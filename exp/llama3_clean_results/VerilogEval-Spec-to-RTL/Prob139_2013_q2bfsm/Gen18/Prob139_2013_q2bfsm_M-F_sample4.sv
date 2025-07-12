module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    reg [2:0] state;  // 5 states: RESET, F_SET, X_DETECT, Y_DETECT, FINAL
    reg [2:0] x_count;  // counter for x sequence detection
    reg [1:0] y_count;  // counter for y detection
    reg reset_deasserted;  // flag to track when reset is de-asserted

    always @ (posedge clk) begin
        if (!resetn) begin
            state <= 3'b000;  // RESET state
            f <= 0;
            g <= 0;
            x_count <= 0;
            y_count <= 0;
            reset_deasserted <= 0;
        end else begin
            case (state)
                3'b000: begin  // RESET state
                    if (!reset_deasserted) begin
                        reset_deasserted <= 1;
                    end else begin
                        state <= 3'b001;  // transition to F_SET state
                        f <= 1;
                    end
                end
                3'b001: begin  // F_SET state
                    state <= 3'b010;  // transition to X_DETECT state
                    f <= 0;
                end
                3'b010: begin  // X_DETECT state
                    if (x_count == 0 && x) begin
                        x_count <= 1;
                    end else if (x_count == 1 && !x) begin
                        x_count <= 2;
                    end else if (x_count == 2 && x) begin
                        state <= 3'b011;  // transition to Y_DETECT state
                        x_count <= 0;
                        y_count <= 0;
                    end else if (x_count != 0) begin
                        x_count <= 0;
                    end
                end
                3'b011: begin  // Y_DETECT state
                    if (y) begin
                        state <= 3'b100;  // transition to FINAL state
                        g <= 1;
                    end else begin
                        y_count <= y_count + 1;
                        if (y_count == 2) begin
                            state <= 3'b100;  // transition to FINAL state
                            g <= 0;
                        end
                    end
                end
                3'b100: begin  // FINAL state
                    // no transition
                end
            endcase
        end
    end
endmodule