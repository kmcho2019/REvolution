module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00; // IDLE state
    end else begin
        case(state)
            2'b00: // IDLE state
                if (x == 1'b1) begin
                    state <= 2'b01; // FIRST state
                end
            2'b01: // FIRST state
                if (x == 1'b0) begin
                    state <= 2'b10; // SECOND state
                end else if (x == 1'b1) begin
                    state <= 2'b01; // Stay in FIRST state if x is '1'
                end
            2'b10: // SECOND state
                if (x == 1'b1) begin
                    state <= 2'b00; // Back to IDLE state
                end else begin
                    state <= 2'b10; // Stay in SECOND state if x is '0'
                end
            default: state <= 2'b00;
        endcase
    end
end

assign z = (state == 2'b10 && x == 1'b1);

endmodule