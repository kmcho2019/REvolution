module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // idle, sequence_started, sequence_found

always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00; // idle
    end else begin
        case (state)
            2'b00: begin // idle
                if (x == 1'b1) begin
                    state <= 2'b01; // sequence_started
                end
            end
            2'b01: begin // sequence_started
                if (x == 1'b0) begin
                    state <= 2'b10; // sequence_found
                end else begin
                    state <= 2'b00; // reset to idle
                end
            end
            2'b10: begin // sequence_found
                if (x == 1'b1) begin
                    state <= 2'b10; // stay in sequence_found
                end else begin
                    state <= 2'b00; // reset to idle
                end
            end
        endcase
    end
end

assign z = (state == 2'b10);

endmodule