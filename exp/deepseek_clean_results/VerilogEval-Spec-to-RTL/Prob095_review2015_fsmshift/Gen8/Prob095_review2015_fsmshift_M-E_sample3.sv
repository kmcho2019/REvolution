module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] state, next_state;
    reg [1:0] cycle_count;
    
    localparam IDLE   = 2'b00;
    localparam COUNTING = 2'b01;
    localparam DONE   = 2'b10;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= COUNTING;
            cycle_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == COUNTING) begin
                cycle_count <= cycle_count + 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = IDLE;
            COUNTING: next_state = (cycle_count == 2'b11) ? DONE : COUNTING;
            DONE:    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            COUNTING: shift_ena = 1'b1;
            default:  shift_ena = 1'b0;
        endcase
    end

endmodule