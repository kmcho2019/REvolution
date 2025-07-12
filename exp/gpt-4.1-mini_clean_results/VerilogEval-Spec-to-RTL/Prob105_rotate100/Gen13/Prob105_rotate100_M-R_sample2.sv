module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

integer i;
reg [99:0] next_q;

always @(*) begin
    // Default next state is current state (hold)
    next_q = q;
    if (load) begin
        // Load input data synchronously
        next_q = data;
    end else begin
        case (ena)
            2'b10: begin // Rotate left
                for (i = 0; i < 99; i = i + 1) begin
                    next_q[i] = q[i+1];
                end
                next_q[99] = q[0];
            end
            2'b01: begin // Rotate right
                next_q[0] = q[99];
                for (i = 1; i < 100; i = i + 1) begin
                    next_q[i] = q[i-1];
                end
            end
            default: begin
                // No rotation, hold current state
                next_q = q;
            end
        endcase
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule