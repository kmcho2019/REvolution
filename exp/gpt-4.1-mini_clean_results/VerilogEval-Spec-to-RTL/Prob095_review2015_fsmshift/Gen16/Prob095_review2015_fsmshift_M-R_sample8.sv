module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    // State encoding
    localparam IDLE  = 1'b0;
    localparam SHIFT = 1'b1;

    reg state;
    reg [2:0] counter;  // counts down from 4 to 0

    // State and counter update logic
    always @(posedge clk) begin
        if (reset) begin
            state   <= SHIFT;
            counter <= 3'd4;
        end else begin
            case (state)
                IDLE: begin
                    // No pattern detection input given, so stay IDLE forever after shift_ena completes
                    state <= IDLE;
                    counter <= 3'd0;
                end

                SHIFT: begin
                    if (counter == 3'd1) begin
                        // Last cycle of shift_ena, next cycle go IDLE
                        state   <= IDLE;
                        counter <= 3'd0;
                    end else begin
                        counter <= counter - 1'b1;
                        state <= SHIFT;
                    end
                end

                default: begin
                    state <= IDLE;
                    counter <= 3'd0;
                end
            endcase
        end
    end

    // Output logic: shift_ena asserted while counter is nonzero (during SHIFT state)
    assign shift_ena = (counter != 3'd0);

endmodule