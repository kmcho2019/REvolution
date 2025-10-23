module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Intermediate wire for next q value
    reg [99:0] q_next;

    // Combinational logic for rotation or load
    always @(*) begin
        if (load) begin
            // Load data synchronously
            q_next = data;
        end else begin
            case (ena)
                2'b01: 
                    // Rotate right by one bit
                    q_next = {q[0], q[99:1]};
                2'b10: 
                    // Rotate left by one bit
                    q_next = {q[98:0], q[99]};
                default:
                    // No rotation
                    q_next = q;
            endcase
        end
    end

    // Register update on clock edge
    always @(posedge clk) begin
        q <= q_next;
    end

endmodule