module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

typedef enum logic [0:0] {A, B} state_type;
state_type state, next_state;

reg [1:0] w_count; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for 3-cycle window

// Combinational logic for next state
always @(*) begin
    case(state)
        A: begin
            if(s) begin
                next_state = B;
            end
            else begin
                next_state = A;
            end
        end
        B: begin
            next_state = B; // Stay in state B
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
        if(state == B) begin
            if(w) begin
                w_count <= w_count + 1;
            end
            cycle_count <= cycle_count + 1;
            
            // Check for 3-cycle window and set z
            if(cycle_count == 2) begin
                if(w_count == 2) begin
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
                w_count <= 0;
                cycle_count <= 0;
            end
        end
        else begin
            w_count <= 0;
            cycle_count <= 0;
        end
    end
end

endmodule