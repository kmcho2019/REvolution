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
    reg [1:0] shift_counter;
    reg [3:0] pattern_reg;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_counter <= 0;
            pattern_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_counter <= 0;
                    end
                end
                
                SHIFT: begin
                    if (shift_counter == 2'b11)
                        state <= COUNT;
                    shift_counter <= shift_counter + 1;
                end
                
                COUNT: begin
                    if (done_counting)
                        state <= DONE;
                end
                
                DONE: begin
                    if (ack)
                        state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Output logic
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule