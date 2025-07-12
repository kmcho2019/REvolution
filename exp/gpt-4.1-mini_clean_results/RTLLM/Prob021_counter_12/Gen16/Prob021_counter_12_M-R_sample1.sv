module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// State encoding (not strictly necessary but illustrates FSM style)
localparam COUNT   = 1'b1,
           HOLD    = 1'b0;

reg state, next_state;
reg [3:0] next_out;

// Synchronous register for state and output
always @(posedge clk) begin
    if (!rst_n) begin
        state <= HOLD;
        out   <= 4'b0000;
    end else begin
        state <= next_state;
        out   <= next_out;
    end
end

// Next state and output logic
always @(*) begin
    case (state)
        HOLD: begin
            if (valid_count) begin
                next_state = COUNT;
                next_out = (out == 4'd11) ? 4'b0000 : out + 1'b1;
            end else begin
                next_state = HOLD;
                next_out = out;
            end
        end

        COUNT: begin
            if (valid_count) begin
                if (out == 4'd11) begin
                    next_state = COUNT;
                    next_out = 4'b0000;
                end else begin
                    next_state = COUNT;
                    next_out = out + 1'b1;
                end
            end else begin
                next_state = HOLD;
                next_out = out;  // hold count
            end
        end

        default: begin
            next_state = HOLD;
            next_out = 4'b0000;
        end
    endcase
end

endmodule