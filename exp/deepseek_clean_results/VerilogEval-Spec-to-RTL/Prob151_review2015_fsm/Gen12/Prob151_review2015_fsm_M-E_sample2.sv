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

    // Phase tracking
    reg [1:0] phase;
    localparam PH_IDLE     = 2'b00;
    localparam PH_SHIFT    = 2'b01;
    localparam PH_COUNTING = 2'b10;
    localparam PH_DONE     = 2'b11;

    // Unified shift register (5 bits: 4 for pattern + 1 extra)
    reg [4:0] shift_reg;
    
    // Cycle counter for shift phase
    reg [1:0] cycle_ctr;

    // State machine
    reg state, next_state;
    localparam ST_IDLE = 1'b0;
    localparam ST_WORK = 1'b1;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= ST_IDLE;
            phase <= PH_IDLE;
            shift_reg <= 5'b0;
            cycle_ctr <= 2'b0;
        end else begin
            state <= next_state;
            shift_reg <= {shift_reg[3:0], data};

            case (phase)
                PH_SHIFT: begin
                    if (cycle_ctr == 2'b11)
                        phase <= PH_COUNTING;
                    else
                        cycle_ctr <= cycle_ctr + 1'b1;
                end
                PH_COUNTING: if (done_counting) phase <= PH_DONE;
                PH_DONE: if (ack) phase <= PH_IDLE;
                default: ; // PH_IDLE stays until pattern found
            endcase

            // Pattern detection triggers shift phase
            if (phase == PH_IDLE && shift_reg[3:0] == 4'b1101) begin
                phase <= PH_SHIFT;
                cycle_ctr <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            ST_IDLE: next_state = (shift_reg[3:0] == 4'b1101) ? ST_WORK : ST_IDLE;
            ST_WORK: next_state = (phase == PH_DONE && ack) ? ST_IDLE : ST_WORK;
            default: next_state = ST_IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (phase == PH_SHIFT);
    assign counting = (phase == PH_COUNTING);
    assign done = (phase == PH_DONE);

endmodule