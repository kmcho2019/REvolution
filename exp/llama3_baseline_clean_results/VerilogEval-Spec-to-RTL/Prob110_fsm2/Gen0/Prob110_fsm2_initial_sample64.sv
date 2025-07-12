module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

// Define states as parameters
parameter OFF = 1'b0, ON = 1'b1;

reg current_state;

// Reset to OFF state asynchronously
always @(posedge areset or posedge clk) begin
    if(areset) begin
        current_state <= OFF;
    end else begin
        case(current_state)
            OFF: begin
                if(j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if(k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
            default: current_state <= OFF;
        endcase
    end
end

// Output calculation based on the current state
always @(*) begin
    case(current_state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule