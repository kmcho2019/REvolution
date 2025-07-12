module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {A = 1'b0, B = 1'b1} state_t;
    state_t state, next_state;

    reg [1:0] cycle, next_cycle;
    reg [1:0] w_acc, next_w_acc;
    reg next_z;

    // Next state and counters logic
    always @* begin
        // Default assignments to hold current values
        next_state = state;
        next_cycle = cycle;
        next_w_acc = w_acc;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0;
                next_cycle = 2'd0;
                next_w_acc = 2'd0;
                if (s)
                    next_state = B;
            end
            B: begin
                next_w_acc = w_acc + w;
                if (cycle == 2) begin
                    // After counting 3 cycles (0,1,2)
                    next_z = ((w_acc + w) == 2);
                    next_cycle = 2'd0;
                    next_w_acc = 2'd0;
                end else begin
                    next_z = 1'b0;
                    next_cycle = cycle + 1;
                end
            end
        endcase
    end

    // Sequential logic: state and outputs update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle <= 2'd0;
            w_acc <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle <= next_cycle;
            w_acc <= next_w_acc;
            z <= next_z;
        end
    end

endmodule