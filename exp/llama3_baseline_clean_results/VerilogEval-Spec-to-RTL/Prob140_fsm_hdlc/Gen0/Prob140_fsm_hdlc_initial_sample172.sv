module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// Define states
enum {IDLE, FLAG5, FLAG, ERROR} state, nextState;

// Default values for outputs
assign disc = 0;
assign flag = 0;
assign err = 0;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= nextState;
        case(state)
            FLAG5: if (in) begin
                disc <= 1; // signal a bit needs to be discarded
            end
            FLAG: begin
                flag <= 1; // signal the beginning/end of a frame
            end
            ERROR: begin
                err <= 1; // signal an error
            end
        endcase
    end
end

always_comb begin
    case(state)
        IDLE: begin
            if (in) begin
                nextState = FLAG5;
            end else begin
                nextState = IDLE;
            end
        end
        FLAG5: begin
            if (in) begin
                nextState = FLAG;
            end else begin
                nextState = IDLE;
            end
        end
        FLAG: begin
            if (in) begin
                nextState = ERROR;
            end else begin
                nextState = IDLE;
            end
        end
        ERROR: begin
            if (in) begin
                nextState = ERROR;
            end else begin
                nextState = IDLE;
            end
        end
    endcase
end

endmodule