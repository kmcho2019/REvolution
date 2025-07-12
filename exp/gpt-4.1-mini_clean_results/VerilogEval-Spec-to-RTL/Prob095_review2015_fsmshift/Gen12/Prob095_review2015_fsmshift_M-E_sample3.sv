module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam ACTIVE = 1'b1;

    reg state;
    reg [2:0] counter;  // 3 bits to count down 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset asserted, enter ACTIVE state with counter=4
            state     <= ACTIVE;
            counter   <= 3'd4;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                ACTIVE: begin
                    if (counter > 0) begin
                        counter   <= counter - 3'd1;
                        shift_ena <= 1'b1;
                    end
                    if (counter == 1) begin
                        // On last active cycle, next cycle move to IDLE
                        state     <= IDLE;
                        shift_ena <= 1'b0;
                    end
                end

                IDLE: begin
                    // Remain idle, shift_ena low
                    shift_ena <= 1'b0;
                    counter   <= 3'd0;
                    state     <= IDLE;
                end

                default: begin
                    // Safety default
                    state     <= IDLE;
                    shift_ena <= 1'b0;
                    counter   <= 3'd0;
                end
            endcase
        end
    end

endmodule