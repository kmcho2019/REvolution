module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
reg prev_x;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00;
        prev_x <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (x == 1'b1) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (x == 1'b0) begin
                    state <= 2'b10;
                end else if (x == 1'b1) begin
                    state <= 2'b01;
                end
            end
            2'b10: begin
                if (x == 1'b1) begin
                    state <= 2'b00;
                    z <= 1'b1;
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