module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00; // IDLE state
    end else begin
        case (state)
            2'b00: // IDLE state
                if (x) begin
                    state <= 2'b01; // WAIT_0 state
                end
            2'b01: // WAIT_0 state
                if (!x) begin
                    state <= 2'b10; // WAIT_1 state
                end else begin
                    state <= 2'b00; // IDLE state
                end
            2'b10: // WAIT_1 state
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

// Output logic
assign z = (state == 2'b10) && x;

endmodule