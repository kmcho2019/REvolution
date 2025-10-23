module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam ACTIVE = 1'b1;

    reg state, next_state;
    reg [2:0] count; // 3 bits to count up to 4

    // Next state logic and counter
    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == ACTIVE)
                count <= count + 1;
            else
                count <= 3'd0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            ACTIVE: begin
                if (count == 3'd3)
                    next_state = IDLE;
                else
                    next_state = ACTIVE;
            end
            IDLE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == ACTIVE);
    end

endmodule