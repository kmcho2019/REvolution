module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State encoding
    reg [1:0] state;
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    // Pattern detection shift register
    reg [3:0] shift_reg;
    reg [1:0] shift_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            shift_count <= 2'b0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Check pattern before shifting
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_ena <= 1'b1;
                        shift_count <= 2'b0;
                    end
                    shift_reg <= {shift_reg[2:0], data};
                end

                SHIFT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_count == 2'b11) begin  // After 4 cycles (0-3)
                        state <= COUNTING;
                        shift_ena <= 1'b0;
                        counting <= 1'b1;
                    end else begin
                        shift_count <= shift_count + 1'b1;
                    end
                end

                COUNTING: begin
                    if (done_counting) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule