module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00; // IDLE state
    end else begin
        case (state)
            2'b00: // IDLE state
                if (x) begin
                    state <= 2'b01; // STATE1
                end else begin
                    state <= 2'b00; // IDLE state
                end
            2'b01: // STATE1
                if (!x) begin
                    state <= 2'b10; // STATE2
                end else begin
                    state <= 2'b01; // STATE1
                end
            2'b10: // STATE2
                if (x) begin
                    state <= 2'b00; // IDLE state
                end else begin
                    state <= 2'b00; // IDLE state
                end
            default:
                state <= 2'b00; // IDLE state
        endcase
    end
end

assign z = (state == 2'b10) && x;

endmodule