module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    reg [1:0] state;  // 4 states: RESET, F_SET, X_DETECT, Y_DETECT, FINAL
    reg [1:0] x_count;  // counter for x sequence detection
    reg [1:0] y_count;  // counter for y detection
    reg x_seq_detected;  // flag to track x sequence detection
    reg y_detected;  // flag to track y detection

    always @ (posedge clk) begin
        if (!resetn) begin
            state <= 2'b00;  // RESET state
            f <= 0;
            g <= 0;
            x_count <= 0;
            y_count <= 0;
            x_seq_detected <= 0;
            y_detected <= 0;
        end else begin
            case (state)
                2'b00: begin  // RESET state
                    state <= 2'b01;  // transition to F_SET state
                    f <= 1;
                end
                2'b01: begin  // F_SET state
                    state <= 2'b10;  // transition to X_DETECT state
                    f <= 0;
                    x_count <= 0;
                end
                2'b10: begin  // X_DETECT state
                    if (x_count == 0 && x) begin
                        x_count <= 1;
                    end else if (x_count == 1 && !x) begin
                        x_count <= 2;
                    end else if (x_count == 2 && x) begin
                        state <= 2'b11;  // transition to Y_DETECT state
                        x_count <= 0;
                        y_count <= 0;
                        x_seq_detected <= 1;
                    end else if (x_count != 0) begin
                        x_count <= 0;
                    end
                end
                2'b11: begin  // Y_DETECT state
                    if (y) begin
                        state <= 2'b00;  // transition to FINAL state
                        g <= 1;
                        y_detected <= 1;
                    end else begin
                        y_count <= y_count + 1;
                        if (y_count == 2) begin
                            state <= 2'b00;  // transition to FINAL state
                            g <= 0;
                            y_detected <= 0;
                        end
                    end
                end
            endcase
        end
    end
endmodule