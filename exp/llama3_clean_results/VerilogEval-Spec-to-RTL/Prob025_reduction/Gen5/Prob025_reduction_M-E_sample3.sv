module TopModule(
    input  [7:0] in,  // 8-bit input
    input        clk, // Clock signal
    input        rst, // Reset signal
    output       parity, // 1-bit parity output
    output       done // Done signal
);

reg [2:0] state; // FSM states: Idle, Calculate, Done
reg [7:0] bit_count; // Counter for bits processed
reg        temp_parity; // Temporary parity storage

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0; // Reset to Idle state
        bit_count <= 0;
        temp_parity <= 0;
        parity <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (in != 0) begin // Start condition
                    state <= 1; // Transition to Calculate state
                    bit_count <= 0;
                    temp_parity <= 0;
                end
            end
            1: begin // Calculate state
                temp_parity <= temp_parity ^ in[bit_count];
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin // All bits processed
                    state <= 2; // Transition to Done state
                end
            end
            2: begin // Done state
                parity <= temp_parity;
                done <= 1;
                if (~in) begin // Reset condition
                    state <= 0; // Transition back to Idle state
                    bit_count <= 0;
                    temp_parity <= 0;
                    parity <= 0;
                    done <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule