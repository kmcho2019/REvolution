module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
localparam STATE_A = 0;
localparam STATE_B = 1;

reg state; // Current state
reg [1:0] cycle_count; // Counter for cycles
reg [1:0] w_count; // Counter for w = 1

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        cycle_count <= 0;
        w_count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    cycle_count <= 1;
                    w_count <= w ? 1 : 0;
                end
                else begin
                    z <= 0; // Ensure z is reset when in STATE_A
                end
            end
            STATE_B: begin
                if(w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if(cycle_count == 3) begin
                    z <= (w_count == 2) ? 1 : 0;
                    cycle_count <= 1;
                    w_count <= w ? 1 : 0;
                    if(!s) begin // Transition back to STATE_A if s is 0
                        state <= STATE_A;
                        z <= 0; // Reset z when transitioning back to STATE_A
                    end
                end
            end
        endcase
    end
end

endmodule