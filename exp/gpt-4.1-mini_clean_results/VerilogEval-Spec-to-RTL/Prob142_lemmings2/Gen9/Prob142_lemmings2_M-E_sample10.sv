module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // direction: 0 = left, 1 = right
    reg direction;
    // falling flag: 0 = on ground, 1 = falling
    reg falling;

    wire bump_any = bump_left | bump_right;

    // Direction next logic
    // Only update direction on ground and bump (including both sides)
    wire direction_next = (ground && bump_any) ? ~direction : direction;

    // Falling next logic
    // Falling is set when ground is lost, cleared when ground returns
    wire falling_next = ground ? 1'b0 : 1'b1;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left on reset
            falling   <= 1'b0; // not falling on reset
        end else begin
            // Falling flip-flop updates first to capture ground status
            falling <= falling_next;
            // Direction updates only if not falling after clock edge (ground must be 1)
            // But falling is updated together so direction next logic uses ground signal, not falling
            direction <= direction_next;
        end
    end

    // Outputs decoding
    assign aaah       = falling;
    assign walk_left  = (~falling) && (direction == 1'b0);
    assign walk_right = (~falling) && (direction == 1'b1);

endmodule