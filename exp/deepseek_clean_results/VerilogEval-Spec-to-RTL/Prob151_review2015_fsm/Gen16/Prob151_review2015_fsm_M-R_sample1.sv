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
    localparam COUNTING  = 3'b011;
    localparam DONE     = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [2:0] shift_counter;

    // Pattern detection and shift control
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101)
                        state <= SHIFT;
                end
                SHIFT: begin
                    shift_counter <= shift_counter + 1;
                    if (shift_counter == 3'b100)
                        state <= COUNTING;
                end
                COUNTING: begin
                    if (done_counting)
                        state <= DONE;
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                        shift_counter <= 3'b0;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule