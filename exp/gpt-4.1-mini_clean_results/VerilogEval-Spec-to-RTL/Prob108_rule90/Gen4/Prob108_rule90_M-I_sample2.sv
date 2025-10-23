module TopModule (
    input          clk,
    input          load,
    input  [511:0] data,
    output reg [511:0] q
);

    // Stage registers holding shifted neighbor vectors
    reg [511:0] q_left;
    reg [511:0] q_right;

    wire [511:0] next_state;

    // Compute next_state as XOR of left and right neighbors (already registered)
    assign next_state = q_left ^ q_right;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // On load, reset neighbor registers to reflect data with zero boundary
            // q_left = q shifted right by 1 with zero at MSB
            q_left <= {data[510:0], 1'b0};
            // q_right = q shifted left by 1 with zero at LSB
            q_right <= {1'b0, data[511:1]};
        end else begin
            q <= next_state;
            // Update neighbor registers based on current q with zero boundary
            q_left <= {q[510:0], 1'b0};
            q_right <= {1'b0, q[511:1]};
        end
    end

endmodule