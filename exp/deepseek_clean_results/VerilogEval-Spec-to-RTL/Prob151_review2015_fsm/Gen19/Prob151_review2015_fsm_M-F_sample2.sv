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
    localparam SHIFT     = 3'b001;
    localparam COUNTING  = 3'b010;
    localparam DONE      = 3'b011;

    reg [2:0] state;
    reg [3:0] pattern;
    reg [1:0] shift_count;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        shift_count <= 2'b0;
                    end
                end

                SHIFT: begin
                    if (shift_count == 2'b11) begin
                        state <= COUNTING;
                    end
                    shift_count <= shift_count + 1;
                end

                COUNTING: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule