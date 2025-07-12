module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] state;
    reg init_done;

    // Next state logic and output combinational logic
    reg [2:0] next_state;
    reg       next_z;

    always @(*) begin
        case (state)
            3'b000: begin
                next_state = (x == 1'b0) ? 3'b000 : 3'b001;
                next_z = 1'b0;
            end
            3'b001: begin
                next_state = (x == 1'b0) ? 3'b001 : 3'b100;
                next_z = 1'b0;
            end
            3'b010: begin
                next_state = (x == 1'b0) ? 3'b010 : 3'b001;
                next_z = 1'b0;
            end
            3'b011: begin
                next_state = (x == 1'b0) ? 3'b001 : 3'b010;
                next_z = 1'b1;
            end
            3'b100: begin
                next_state = (x == 1'b0) ? 3'b011 : 3'b100;
                next_z = 1'b1;
            end
            default: begin
                // For undefined states, stay in state 000 and z=0
                next_state = 3'b000;
                next_z = 1'b0;
            end
        endcase
    end

    // Synchronous state update
    always @(posedge clk) begin
        // On first clock, load state from input y, then ignore input y
        if (!init_done) begin
            state <= y;
            init_done <= 1'b1;
        end else begin
            state <= next_state;
        end
    end

    // Output assignments
    assign z = next_z;
    assign Y0 = next_state[0];

endmodule