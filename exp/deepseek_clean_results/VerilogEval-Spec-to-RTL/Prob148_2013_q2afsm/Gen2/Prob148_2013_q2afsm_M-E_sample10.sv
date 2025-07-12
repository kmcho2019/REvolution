module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Current grant tracking (one-hot encoded)
    reg [2:0] current_grant;

    // Priority encoder for new grants
    wire [2:0] next_grant;
    assign next_grant = r[0] ? 3'b001 : 
                       r[1] ? 3'b010 : 
                       r[2] ? 3'b100 : 
                       3'b000;

    // Grant maintenance logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_grant <= 3'b000;
            g <= 3'b000;
        end
        else begin
            // Maintain grant if request still active
            if ((current_grant & r) != 0) begin
                current_grant <= current_grant;
            end
            // Otherwise take new grant if available
            else if (next_grant != 0) begin
                current_grant <= next_grant;
            end
            // No requests - clear grants
            else begin
                current_grant <= 3'b000;
            end
            
            // Registered outputs
            g <= current_grant;
        end
    end

endmodule