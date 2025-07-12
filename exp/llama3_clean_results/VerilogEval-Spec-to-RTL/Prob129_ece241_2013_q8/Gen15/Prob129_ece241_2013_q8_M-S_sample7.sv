module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset and sequential logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00; // idle state
    end else begin
        case (state)
            2'b00: begin // idle state
                if (x) begin
                    state <= 2'b01; // seen_1 state
                end
            end
            2'b01: begin // seen_1 state
                if (!x) begin
                    state <= 2'b10; // seen_10 state
                end else begin
                    state <= 2'b01; // seen_1 state
                end
            end
            2'b10: begin // seen_10 state
                if (x) begin
                    state <= 2'b01; // seen_1 state
                end else begin
                    state <= 2'b10; // seen_10 state
                end
            end
        endcase
    end
end

// Output logic
assign z = (state == 2'b10) && x;

endmodule