module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [2:0] current_grant;  // Tracks which device currently has grant

    // Priority encoder for new grants
    wire [2:0] new_grant;
    assign new_grant = r[0] ? 3'b001 :    // Device 0 has highest priority
                      r[1] ? 3'b010 :    // Then device 1
                      r[2] ? 3'b100 :    // Then device 2
                      3'b000;            // No requests

    // Grant logic: hold current grant if request still active, otherwise get new grant
    wire [2:0] next_grant;
    assign next_grant = (|(current_grant & r)) ? current_grant : new_grant;

    // Sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_grant <= 3'b000;  // Reset to no grants
        end else begin
            current_grant <= next_grant;
        end
    end

    // Output assignment
    assign g = current_grant;

endmodule