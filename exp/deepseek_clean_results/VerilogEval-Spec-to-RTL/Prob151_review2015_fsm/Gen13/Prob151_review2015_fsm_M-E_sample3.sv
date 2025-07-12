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

    reg [7:0] control_reg;
    reg done_flag;

    // Main control register update
    always @(posedge clk) begin
        if (reset) begin
            control_reg <= 8'b0;
            done_flag <= 1'b0;
        end else begin
            casez (control_reg)
                // IDLE state - waiting for 1101 pattern
                8'b00000000: begin
                    control_reg <= {control_reg[6:0], data};
                    if ({control_reg[2:0], data} == 4'b1101)
                        control_reg <= 8'b11010000;
                end

                // Pattern detected - shifting next 4 bits
                8'b1101????: begin
                    if (control_reg[3:0] != 4'b1111) begin
                        control_reg <= {4'b1101, control_reg[2:0], 1'b1};
                    end
                end

                default: control_reg <= control_reg;
            endcase

            // Done counting transition
            if (control_reg == 8'b11011111 && done_counting)
                done_flag <= 1'b1;

            // Acknowledge handling
            if (done_flag && ack) begin
                control_reg <= 8'b0;
                done_flag <= 1'b0;
            end
        end
    end

    // Output assignments
    assign shift_ena = (control_reg[7:4] == 4'b1101) && 
                      (control_reg[3:0] != 4'b1111);
    assign counting = (control_reg == 8'b11011111) && !done_counting;
    assign done = done_flag;

endmodule