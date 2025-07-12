module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // idle (2'b00), seen_1 (2'b01), seen_10 (2'b10)

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin
                if (x) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (!x) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b01;
                end
            end
            2'b10: begin
                if (x) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

// Output logic
assign z = (state == 2'b10) && x;

endmodule