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

    // One-hot state encoding
    localparam S_IDLE        = 4'b0001;
    localparam S_SHIFT_1     = 4'b0010;
    localparam S_SHIFT_2     = 4'b0100;
    localparam S_SHIFT_3     = 4'b1000;
    localparam S_COUNTING    = 4'b0001;  // Reuse IDLE encoding
    localparam S_DONE        = 4'b0010;  // Reuse SHIFT_1 encoding
    localparam S_DONE_WAIT   = 4'b0100;  // Reuse SHIFT_2 encoding

    reg [3:0] state;
    reg [3:0] shift_reg;  // Pattern detection shift register
    reg shift_active;     // Enable signal for shift register

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_reg <= 4'b0;
            shift_active <= 1'b1;
        end else begin
            case (state)
                S_IDLE: begin
                    if (shift_active) begin
                        shift_reg <= {shift_reg[2:0], data};
                        
                        // Check for pattern 1101
                        if (shift_reg == 4'b1101) begin
                            state <= S_SHIFT_1;
                            shift_active <= 1'b0;
                        end
                    end
                end

                S_SHIFT_1: state <= S_SHIFT_2;
                S_SHIFT_2: state <= S_SHIFT_3;
                S_SHIFT_3: state <= S_COUNTING;

                S_COUNTING: begin
                    if (done_counting)
                        state <= S_DONE;
                end

                S_DONE: state <= S_DONE_WAIT;

                S_DONE_WAIT: begin
                    if (ack) begin
                        state <= S_IDLE;
                        shift_active <= 1'b1;
                        shift_reg <= 4'b0;
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == S_SHIFT_1) || (state == S_SHIFT_2) || 
                      (state == S_SHIFT_3);
    assign counting  = (state == S_COUNTING);
    assign done      = (state == S_DONE) || (state == S_DONE_WAIT);

endmodule