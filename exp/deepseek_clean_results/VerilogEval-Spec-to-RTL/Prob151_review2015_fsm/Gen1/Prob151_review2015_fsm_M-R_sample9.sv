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
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [2:0] pattern_reg;  // Stores last 3 bits
    reg [1:0] shift_cnt;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 3'b0;
            shift_cnt <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[1:0], data};
                    if (pattern_reg == 3'b110 && data == 1'b1) begin
                        state <= SHIFT;
                        shift_cnt <= 2'b0;
                    end
                end
                SHIFT: begin
                    shift_cnt <= shift_cnt + 1;
                    if (shift_cnt == 2'b11) state <= COUNT;
                end
                COUNT: begin
                    if (done_counting) state <= DONE;
                end
                DONE: begin
                    if (ack) state <= IDLE;
                end
            endcase
        end
    end

    // Output logic - now combinatorial
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule