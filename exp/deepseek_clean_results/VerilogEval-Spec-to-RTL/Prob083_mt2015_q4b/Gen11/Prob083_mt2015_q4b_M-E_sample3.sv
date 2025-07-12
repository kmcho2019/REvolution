module TopModule (
    input x,
    input y,
    output reg z
);

    // Define states
    localparam DEFAULT = 1'b1;
    localparam ACTIVE = 1'b0;

    reg current_state;

    initial begin
        current_state = DEFAULT;
        z = DEFAULT;
    end

    always @(*) begin
        case (current_state)
            DEFAULT: begin
                z = DEFAULT;
                if (x) current_state = ACTIVE;
            end
            ACTIVE: begin
                z = ACTIVE;
                if (x & y) current_state = DEFAULT;
            end
        endcase
    end

endmodule