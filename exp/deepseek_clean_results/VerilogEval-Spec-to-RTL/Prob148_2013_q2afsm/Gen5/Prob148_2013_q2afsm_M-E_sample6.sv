module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Grant tracking register (0 = idle, 1-3 = device granted)
    reg [1:0] current_grantee;

    // Priority encoder for new grants
    wire [1:0] next_grantee;
    assign next_grantee = r[0] ? 2'b01 :  // Device 0 highest priority
                         r[1] ? 2'b10 :  // Device 1 
                         r[2] ? 2'b11 :  // Device 2
                         2'b00;          // No request

    // Grant maintenance logic
    wire maintain_grant = (current_grantee == 2'b01 && r[0]) ||  // Keep grant if requester still active
                         (current_grantee == 2'b10 && r[1]) ||
                         (current_grantee == 2'b11 && r[2]);

    // State update
    always @(posedge clk) begin
        if (!resetn)
            current_grantee <= 2'b00;
        else if (current_grantee == 2'b00)
            current_grantee <= next_grantee;  // Accept new grant when idle
        else if (!maintain_grant)
            current_grantee <= 2'b00;        // Release grant when request drops
    end

    // Output generation
    assign g[0] = (current_grantee == 2'b01);
    assign g[1] = (current_grantee == 2'b10);
    assign g[2] = (current_grantee == 2'b11);

endmodule