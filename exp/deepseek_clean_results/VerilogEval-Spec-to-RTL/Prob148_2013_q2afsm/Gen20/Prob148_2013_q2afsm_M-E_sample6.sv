module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Mini-FSM states (1 bit per device)
    reg [2:0] device_state;

    // Priority encoder
    wire [2:0] priority_grant;
    assign priority_grant[0] = r[0];                         // Highest priority
    assign priority_grant[1] = ~r[0] & r[1];                 // Medium priority
    assign priority_grant[2] = ~r[0] & ~r[1] & r[2];         // Lowest priority

    // Next state logic for each device
    wire [2:0] next_state;
    assign next_state[0] = (device_state[0] & r[0]) |       // Stay active if still requesting
                          (~device_state[0] & priority_grant[0]); // Or get new grant
    assign next_state[1] = (device_state[1] & r[1]) |
                          (~device_state[1] & priority_grant[1]);
    assign next_state[2] = (device_state[2] & r[2]) |
                          (~device_state[2] & priority_grant[2]);

    // State registers for all devices
    always @(posedge clk) begin
        if (!resetn) begin
            device_state <= 3'b000;  // All devices IDLE
        end else begin
            // Only one device can transition per cycle due to priority
            if (priority_grant[0]) begin
                device_state[0] <= next_state[0];
                device_state[1] <= 1'b0;
                device_state[2] <= 1'b0;
            end else if (priority_grant[1]) begin
                device_state[0] <= 1'b0;
                device_state[1] <= next_state[1];
                device_state[2] <= 1'b0;
            end else if (priority_grant[2]) begin
                device_state[0] <= 1'b0;
                device_state[1] <= 1'b0;
                device_state[2] <= next_state[2];
            end else begin
                // No requests - all devices go idle
                device_state <= 3'b000;
            end
        end
    end

    // Outputs are the device states
    assign g = device_state;

endmodule