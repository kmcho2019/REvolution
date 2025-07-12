module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    // Internal wires for rotated versions
    wire [99:0] rotate_left;
    wire [99:0] rotate_right;

    // Generate rotate left by 1: MSB gets LSB
    assign rotate_left  = {q[98:0], q[99]};
    // Generate rotate right by 1: LSB gets MSB
    assign rotate_right = {q[0], q[99:1]};

    // Internal next state wire
    wire [99:0] next_q;

    // Determine which rotation to apply
    // Use combinational logic with explicit muxing per bit for clarity and synthesis efficiency
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : gen_next_q
            assign next_q[i] = load       ? data[i]         :
                               (ena == 2'b10) ? rotate_left[i]  :
                               (ena == 2'b01) ? rotate_right[i] :
                               q[i];
        end
    endgenerate

    // Clock enable signal: high if load or a valid rotation direction requested
    wire update_en = load || (ena == 2'b01) || (ena == 2'b10);

    // Register update only when update_en is high, minimizing toggling and power
    always @(posedge clk) begin
        if (update_en)
            q <= next_q;
    end

endmodule