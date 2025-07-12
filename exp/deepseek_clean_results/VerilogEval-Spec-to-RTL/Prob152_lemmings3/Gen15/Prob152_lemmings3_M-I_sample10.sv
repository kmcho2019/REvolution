module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // States with efficient binary encoding
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    reg [3:0] outputs, next_outputs; // Registered outputs

    // State and direction update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            outputs <= 4'b1000; // walk_left=1, others=0
        end
        else begin
            state <= next_state;
            direction <= next_direction;
            outputs <= next_outputs;
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_direction = direction;
        next_outputs = 4'b0000;

        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    next_outputs = 4'b0010; // aaah=1
                end
                else if (dig) begin
                    next_state = DIG;
                    next_outputs = 4'b0001; // digging=1
                end
                else begin
                    // Only update direction when walking on ground
                    if (bump_left || bump_right) begin
                        next_direction = bump_left;
                    end
                    next_outputs = {~direction, direction, 1'b0, 1'b0};
                end
            end

            FALL: begin
                next_outputs = 4'b0010; // aaah=1
                if (ground) begin
                    next_state = WALK;
                    next_outputs = {~direction, direction, 1'b0, 1'b0};
                end
            end

            DIG: begin
                next_outputs = 4'b0001; // digging=1
                if (!ground) begin
                    next_state = FALL;
                    next_outputs = 4'b0010; // aaah=1
                end
            end
        endcase
    end

    // Output assignments
    assign {walk_left, walk_right, aaah, digging} = outputs;

endmodule