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

    // States
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [7:0] pattern_reg;  // [3:0] for pattern, [7:4] for shift count

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 8'b0;
        end else begin
            pattern_reg <= {pattern_reg[6:0], data};
            
            case (state)
                IDLE:  if (pattern_reg[3:0] == 4'b1101) state <= SHIFT;
                SHIFT: if (&pattern_reg[7:4]) state <= COUNT;  // All 1's after 4 shifts
                COUNT: if (done_counting) state <= DONE;
                DONE:  if (ack) state <= IDLE;
            endcase
        end
    end

    // Outputs directly tied to state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule