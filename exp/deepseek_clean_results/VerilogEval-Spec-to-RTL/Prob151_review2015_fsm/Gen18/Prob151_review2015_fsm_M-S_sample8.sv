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

    // Gray state encoding
    localparam IDLE     = 3'b000;
    localparam SHIFT1   = 3'b001;
    localparam SHIFT2   = 3'b011;
    localparam SHIFT3   = 3'b010;
    localparam COUNTING = 3'b110;
    localparam DONE     = 3'b100;

    reg [2:0] state;
    reg [1:0] pattern_reg; // Only need to track last 2 bits

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[0], data};
                    if (pattern_reg == 2'b11 && data == 1'b0) // 110 pattern
                        state <= SHIFT1;
                end

                SHIFT1: state <= SHIFT2;
                SHIFT2: state <= SHIFT3;
                SHIFT3: state <= COUNTING;

                COUNTING: begin
                    if (done_counting)
                        state <= DONE;
                end

                DONE: begin
                    if (ack)
                        state <= IDLE;
                end
            endcase
        end
    end

    assign shift_ena = (state == SHIFT1 || state == SHIFT2 || state == SHIFT3);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule