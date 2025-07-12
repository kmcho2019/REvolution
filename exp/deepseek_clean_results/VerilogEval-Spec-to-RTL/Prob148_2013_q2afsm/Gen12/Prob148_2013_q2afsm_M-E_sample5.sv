module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Grant tracking register:
    // 000 - idle state (A)
    // 001 - device 0 has grant (g0)
    // 010 - device 1 has grant (g1)
    // 100 - device 2 has grant (g2)
    reg [2:0] current_grant;

    always @(posedge clk) begin
        if (!resetn) begin
            current_grant <= 3'b000; // Reset to idle state
        end else begin
            case (current_grant)
                3'b000: begin // Idle state - evaluate new requests
                    if (r[0]) current_grant <= 3'b001; // Highest priority
                    else if (r[1]) current_grant <= 3'b010;
                    else if (r[2]) current_grant <= 3'b100;
                end
                3'b001: begin // Device 0 has grant
                    if (!r[0]) current_grant <= 3'b000; // Release if request drops
                end
                3'b010: begin // Device 1 has grant
                    if (!r[1]) current_grant <= 3'b000; // Release if request drops
                end
                3'b100: begin // Device 2 has grant
                    if (!r[2]) current_grant <= 3'b000; // Release if request drops
                end
                default: current_grant <= 3'b000; // Handle undefined states
            endcase
        end
    end

    // Outputs are simply the current grant bits
    assign g = current_grant;

endmodule