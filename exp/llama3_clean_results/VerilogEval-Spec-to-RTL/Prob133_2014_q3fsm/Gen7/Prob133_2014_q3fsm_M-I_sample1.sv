module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

typedef enum {A, B_WAIT, B_CHECK} state_type;
state_type state, next_state;

reg [1:0] w_count; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for 3-cycle window

// Combinational logic for next state
always @(*) begin
    case(state)
        A: begin
            if(s) begin
                next_state = B_WAIT;
            end
            else begin
                next_state = A;
            end
        end
        B_WAIT: begin
            next_state = (cycle_count == 2)? B_CHECK : B_WAIT;
        end
        B_CHECK: begin
            next_state = B_WAIT;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        state <= A;
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end
    else begin
        state <= next_state;
        
        // Update w_count and cycle_count
        case(state)
            B_WAIT: begin
                if(w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
            end
            B_CHECK: begin
                if(w_count == 2) begin
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
                w_count <= 0;
                cycle_count <= 0;
            end
            default: begin
                w_count <= 0;
                cycle_count <= 0;
            end
        endcase
    end
end

endmodule