module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
localparam IDLE = 0;
localparam COUNTING = 1;
localparam SET_OUTPUT = 2;

reg [1:0] state; // Current state
reg [1:0] w_count; // Counter for w = 1
reg [1:0] cycle_count; // Counter for the three cycles

always @(posedge clk) begin
    if(reset) begin
        // Reset logic
        state <= IDLE;
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            IDLE: begin
                // Transition from IDLE to COUNTING when s = 1
                if(s) begin
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                // Increment cycle count
                cycle_count <= cycle_count + 1;
                // Count w = 1
                if(w) begin
                    w_count <= w_count + 1;
                end
                // Check if three cycles have passed
                if(cycle_count == 3) begin
                    state <= SET_OUTPUT;
                end
            end
            SET_OUTPUT: begin
                // Set z based on w_count
                if(w_count == 2) begin
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
                // Reset counters and state
                w_count <= 0;
                cycle_count <= 0;
                state <= COUNTING;
            end
        endcase
    end
end

endmodule