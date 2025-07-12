module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output z updated from combinational logic after next_state is settled
            z <= z; // Hold by default, updated in separate always block below
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        if (areset) begin
            next_state = COPY;
        end else begin
            case (state)
                COPY:   next_state = (x == 1'b1) ? INVERT : COPY;
                INVERT: next_state = INVERT;
                default: next_state = COPY;
            endcase
        end
    end

    // Moore output logic (combinational)
    reg next_z;
    always @(*) begin
        case (state)
            COPY:   next_z = x;
            INVERT: next_z = ~x;
            default: next_z = 1'b0;
        endcase
    end

    // Update output register synchronously, separate from state update to reduce logic depth
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            z <= next_z;
        end
    end

endmodule