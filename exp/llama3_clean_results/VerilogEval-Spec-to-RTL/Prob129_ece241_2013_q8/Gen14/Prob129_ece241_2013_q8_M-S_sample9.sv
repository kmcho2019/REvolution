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
        state <= 2'b00; // idle
    end else begin
        case (state)
'b00: begin // idle
                if (x) begin
                    state <= 2'b01; // seen_1
                end
            end
            2'b01: begin // seen_1
                if (!x) begin
                    state <= 2'b10; // seen_ end else begin
                    state <= 2'b01; // seen_1
                end
            end
'b10: begin // seen_10
                if (x) begin
                    state <= 2'b01; // seen_1
                end else begin
                    state <= 2'b00; // idle
                end
            end
        endcase
    end
end

// Output logic
assign z = (state == 2'b10) && x;

endmodule