module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);

// State encoding parameters
parameter RESET_STATE = 1'b0;
parameter DATA_STATE  = 1'b1;

reg state = RESET_STATE;
reg next_state;

// State transition logic
always @(*) begin
    if (ar) begin
        next_state = RESET_STATE;
    end else begin
        case (state)
            RESET_STATE: next_state = d ? DATA_STATE : RESET_STATE;
            DATA_STATE:  next_state = d ? DATA_STATE : RESET_STATE;
            default:     next_state = RESET_STATE;
        endcase
    end
end

// State update on clock edge
always @(posedge clk or posedge ar) begin
    if (ar) begin
        state <= RESET_STATE;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign q = (state == DATA_STATE);

endmodule