module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam A = 3'b001,  // Idle state
               B = 3'b010,  // Grant to device 0
               C = 3'b100,  // Grant to device 1
               D = 3'b000;  // Unused state (would be grant to device 2 if needed)

    reg [2:0] state;
    wire [2:0] next_state;
    wire [2:0] masked_requests;

    // Priority masking: device 0 has highest priority
    assign masked_requests[0] = r[0];
    assign masked_requests[1] = r[1] & ~r[0];  // Mask if higher priority request exists
    assign masked_requests[2] = r[2] & ~(|r[1:0]);  // Mask if any higher priority request exists

    // Next state logic (combinational)
    assign next_state = (!resetn) ? A :  // Reset condition
                       (state != A) ? (r[state >> 1] ? state : A) :  // Maintain grant if request persists
                       (masked_requests[0] ? B :  // Priority order
                        masked_requests[1] ? C :
                        masked_requests[2] ? D : A);

    // State transition (sequential)
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignments (direct from state bits)
    assign g[0] = state[1];  // B state
    assign g[1] = state[2];  // C state
    assign g[2] = (state == 3'b000);  // D state (encoded as 000)

endmodule