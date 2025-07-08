module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    // State encoding
    typedef enum reg {ON, OFF} state_t;
    state_t state, next_state;

    reg [2:0] count; // enough bits to count to 4

    // Synchronous state and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= ON;
            count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == ON)
                count <= count + 3'd1;
            else
                count <= count;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            ON: begin
                if (count == 3'd3) // 4 cycles counted (0 to 3)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            OFF: next_state = OFF;
            default: next_state = OFF;
        endcase
    end

    // Output logic
    always @(*) begin
        case(state)
            ON: shift_ena = 1'b1;
            OFF: shift_ena = 1'b0;
            default: shift_ena = 1'b0;
        endcase
    end

endmodule