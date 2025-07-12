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
    localparam IDLE      = 2'b00;
    localparam SHIFT     = 2'b01;
    localparam COUNT     = 2'b10;
    localparam DONE      = 2'b11;

    // Pattern detection and shift counter
    reg [3:0] pattern_reg;
    reg [1:0] shift_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            // Update pattern register
            pattern_reg <= {pattern_reg[2:0], data};

            case (state)
                IDLE: begin
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_count <= 2'b0;
                    end
                end

                SHIFT: begin
                    if (shift_count == 2'b11) begin
                        state <= COUNT;
                    end else begin
                        shift_count <= shift_count + 1'b1;
                    end
                end

                COUNT: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase

            // Output generation
            shift_ena <= (state == SHIFT);
            counting <= (state == COUNT);
            done <= (state == DONE);
        end
    end

endmodule