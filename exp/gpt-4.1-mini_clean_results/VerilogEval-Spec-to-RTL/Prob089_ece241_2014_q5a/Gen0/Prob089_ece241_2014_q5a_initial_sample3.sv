module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

// State encoding
localparam BEFORE_ONE = 1'b0;
localparam AFTER_ONE  = 1'b1;

reg state, next_state;
reg next_z;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= BEFORE_ONE;
        z <= 1'b0;
    end else begin
        state <= next_state;
        z <= next_z;
    end
end

// Next state and output logic (Moore output depends on state only)
always @(*) begin
    case (state)
        BEFORE_ONE: begin
            if (x == 1'b1) begin
                next_state = AFTER_ONE;
                next_z = 1'b1; // copy the first '1'
            end else begin
                next_state = BEFORE_ONE;
                next_z = 1'b0; // copy zero
            end
        end
        AFTER_ONE: begin
            next_state = AFTER_ONE;
            next_z = ~x; // invert bits after first 1
        end
        default: begin
            next_state = BEFORE_ONE;
            next_z = 1'b0;
        end
    endcase
end

endmodule