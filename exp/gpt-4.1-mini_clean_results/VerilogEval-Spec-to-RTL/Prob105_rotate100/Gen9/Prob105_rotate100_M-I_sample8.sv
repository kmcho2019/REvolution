module TopModule (
    input        clk,
    input        load,
    input  [1:0] ena,
    input  [99:0] data,
    output reg [99:0] q
);

    // Generate internal enable signal for clock gating
    wire rotate_left  = (ena == 2'b10);
    wire rotate_right = (ena == 2'b01);
    wire en_update = load | rotate_left | rotate_right;

    // Clock gating approach (note: actual gating depends on synthesis tool support)
    // Here we use the enable condition inside always block to minimize toggling
    
    always @(posedge clk) begin
        if (load) begin
            // Load new data synchronously
            q <= data;
        end else if (rotate_right) begin
            // Rotate right by 1 bit
            q <= {q[0], q[99:1]};
        end else if (rotate_left) begin
            // Rotate left by 1 bit
            q <= {q[98:0], q[99]};
        end
        // Else no assignment, q holds its value without toggling
    end

endmodule