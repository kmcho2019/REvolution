module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    // State encoding using localparams for plain Verilog compatibility
    localparam ENABLE  = 1'b0;
    localparam DISABLE = 1'b1;

    reg state, next_state;
    reg [2:0] count, next_count;

    // State and counter sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 3'd0;
            shift_ena <= 1'b1; // Assert shift_ena immediately during reset cycle
        end else begin
            state <= next_state;
            count <= next_count;
            // Output logic depends on state
            shift_ena <= (next_state == ENABLE);
        end
    end

    // Next state and count combinational logic
    always @(*) begin
        case (state)
            ENABLE: begin
                if (count == 3'd3) begin
                    next_state = DISABLE;
                    next_count = count; // hold count at 3 after done
                end else begin
                    next_state = ENABLE;
                    next_count = count + 1;
                end
            end
            DISABLE: begin
                next_state = DISABLE;
                next_count = count;
            end
            default: begin
                next_state = ENABLE;
                next_count = 3'd0;
            end
        endcase
    end

endmodule