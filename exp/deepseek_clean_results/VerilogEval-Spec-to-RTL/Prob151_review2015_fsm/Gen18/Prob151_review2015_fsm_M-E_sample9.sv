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
    localparam IDLE      = 2'b00;
    localparam OPERATING = 2'b01;
    localparam DONE      = 2'b10;

    reg [1:0] state;
    reg [3:0] shift_reg; // Stores pattern and shift count (dual-purpose)
    reg counting_flag;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            counting_flag <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in new data
                    shift_reg <= {shift_reg[2:0], data};
                    
                    // Check for pattern 1101
                    if (shift_reg == 4'b1101) begin
                        state <= OPERATING;
                        shift_reg <= 4'b0; // Reset for shift counting
                    end
                end

                OPERATING: begin
                    if (!counting_flag) begin
                        // Shift phase
                        shift_reg <= shift_reg + 1;
                        if (shift_reg == 4'b0011) begin // After 4 shifts
                            counting_flag <= 1'b1;
                        end
                    end
                    else if (done_counting) begin
                        state <= DONE;
                        counting_flag <= 1'b0;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == OPERATING) && !counting_flag;
    assign counting  = (state == OPERATING) && counting_flag;
    assign done      = (state == DONE);

endmodule