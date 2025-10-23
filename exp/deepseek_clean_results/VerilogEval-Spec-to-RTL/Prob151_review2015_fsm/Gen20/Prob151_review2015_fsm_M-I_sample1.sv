module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    localparam IDLE      = 3'b000;
    localparam DETECT    = 3'b001;
    localparam SHIFT     = 3'b010;
    localparam COUNT     = 3'b011;
    localparam DONE      = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_count;

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_count <= 2'b0;
                    end
                end

                SHIFT: begin
                    if (shift_count == 2'b11) begin
                        state <= COUNT;
                    end else begin
                        shift_count <= shift_count + 1;
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
                        pattern_reg <= 4'b0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule