module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Internal shift registers for pipelined computation
    reg [511:0] q_reg;
    reg [2:0] neighbor_window;  // Stores left, center, right
    reg [8:0] compute_index;    // 0-511 counter
    reg compute_phase;          // 0: load neighbors, 1: compute
    
    // Rule 110 computation result
    wire next_state;
    
    // Optimized Rule 110 logic
    assign next_state = (neighbor_window[2] & neighbor_window[1] & ~neighbor_window[0]) |  // 110
                       (neighbor_window[2] & ~neighbor_window[1] & neighbor_window[0]) |  // 101
                       (~neighbor_window[2] & neighbor_window[1]) |                       // 011 or 010
                       (~neighbor_window[2] & neighbor_window[0]);                       // 001

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_reg <= data;
            compute_index <= 0;
            compute_phase <= 0;
        end else begin
            if (compute_phase == 0) begin
                // Phase 0: Load neighbor window
                if (compute_index == 0) begin
                    neighbor_window <= {q_reg[0], q_reg[0], q_reg[511]};  // Circular boundary
                end else if (compute_index == 511) begin
                    neighbor_window <= {q_reg[510], q_reg[511], q_reg[0]};  // Circular boundary
                end else begin
                    neighbor_window <= q_reg[compute_index +: 3];
                end
                compute_phase <= 1;
            end else begin
                // Phase 1: Compute and store result
                q_reg[compute_index] <= next_state;
                
                if (compute_index == 511) begin
                    // End of cycle - update output
                    q <= q_reg;
                    compute_index <= 0;
                end else begin
                    compute_index <= compute_index + 1;
                end
                compute_phase <= 0;
            end
        end
    end

endmodule