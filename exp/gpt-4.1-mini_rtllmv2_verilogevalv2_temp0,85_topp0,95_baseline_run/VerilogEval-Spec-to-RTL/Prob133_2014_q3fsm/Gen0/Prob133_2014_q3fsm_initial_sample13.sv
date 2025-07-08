module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum reg [2:0] {
        A  = 3'd0,
        B0 = 3'd1,
        B1 = 3'd2,
        B2 = 3'd3,
        B3 = 3'd4
    } state_t;
    
    reg [2:0] state, next_state;
    reg [1:0] w_count; // counts how many times w=1 in the 3-cycle window

    // State and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == B0)
                w_count <= 2'd0;
            else if (state != A && state != B3) begin
                // In B1 or B2 accumulate w_count
                if (w)
                    w_count <= w_count + 1'b1;
            end
            // z is assigned in combinational block below
        end
    end

    // Next state logic and z output
    always @(*) begin
        next_state = state;
        z = 1'b0;
        case(state)
            A: begin
                z = 1'b0;
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B3;
            B3: begin
                z = (w_count == 2);
                next_state = B0;
            end
            default: next_state = A;
        endcase
    end

endmodule